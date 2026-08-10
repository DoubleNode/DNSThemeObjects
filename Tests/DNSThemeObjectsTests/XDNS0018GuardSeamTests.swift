//
//  XDNS0018GuardSeamTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Lieutenant Shaxs (subitem XDNS-0018-007).
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import AnimatedField
import DNSThemeTypes
@testable import DNSThemeObjects

// XDNS-0018-007: guard-effect regression coverage for the fix in
// AnimatedField+dnsApplyStyle.swift (uncommitted at the time this suite was written), which
// removes the `visibleOnImage`/`visibleOffImage` comparisons from the file-private
// `AnimatedFieldFormat.dnsHasSameStateValues(as:)` consumed by the XDNS-0015 guard inside
// `updateForState(using: DNSThemeFieldStyle)`.
//
// THE SEAM BETWEEN TWO PREVIOUSLY-SHIPPED GUARDS (full chain per the XDNS-0018 investigation):
//   1. A cell reconfigure produces a fresh `DNSThemeFieldStyle(from: self)` copy of the current
//      style (e.g. via `dnsFormTitleAlwaysVisible(...)` in DNSForm's cell).
//   2. That copy init's `update(from:)` (DNSThemeTypes/.../DNSThemeFieldStyle.swift:190-191) calls
//      `.copy() as! UIImage` on visibleOnImage/visibleOffImage. UIImage's NSCopying conformance is
//      an unspecified implementation detail -- it may or may not allocate a new instance -- but the
//      copy CONTRACT never promises identity preservation, so a consumer cannot rely on it either way.
//   3. The XDNS-0014 guard (`DNSUIAnimatedField.style.didSet`) routes through
//      `DNSThemeFieldStyle.isDiffFrom` (DNSThemeTypes/.../DNSThemeFieldStyle.swift:267-292), which
//      ALREADY excludes both image fields (lines 282-283, commented out) -> reports "same" -> skips
//      `utilityApply` -> `self.style`'s stored value still updates, but the field's rendered
//      `self.format` is not refreshed from it. `style` and `format` are now silently desynced.
//   4. On focus, the wrapped UITextField's isSelected/isHighlighted toggle, which mirrors
//      unconditionally (DNSUIAnimatedField.swift:77-94) into `updateForState(using:)` using
//      WHATEVER `self.style` currently holds (the desynced copy from step 3).
//   5. BEFORE THIS FIX: the XDNS-0015 guard (`dnsHasSameStateValues`) INCLUDED the image fields.
//      Comparing the desynced style's (instance-churned) images against the currently-applied
//      format's images reports "different" purely from that churn -> `self.format = newFormat` ->
//      AnimatedField's `format.didSet -> setupTitle()` rebuild -> RESIGNS FIRST RESPONDER, even
//      though nothing the user can perceive actually changed.
//
// `dnsHasSameStateValues` is declared in a file-private extension inside the source file under
// test and is NOT reachable from this test target -- it must not be widened to
// internal/public purely to satisfy a test. This suite instead drives the PUBLIC path
// (`DNSUIAnimatedField.isSelected`'s didSet -> `updateForState(using:)`) and asserts on the
// guard's OBSERVABLE EFFECT: whether first-responder status survives a state-driven re-apply whose
// ONLY difference from the currently-applied format is UIImage INSTANCE identity on
// visibleOnImage/visibleOffImage (never their visual content, never any other style field). This
// mirrors the technique DNSUIAnimatedFieldFocusGuardTests.swift (XDNS-0016-003, DNSForm target)
// established for the sibling XDNS-0015 guard, applied here to the narrower XDNS-0018 seam.
//
// ISOLATION TECHNIQUE (why this is airtight regardless of whether `.selected` happens to differ
// from `.normal` for the style in use): the harness applies the SAME state (`isSelected = true`)
// TWICE -- once with the pre-churn style, once with the post-churn style -- rather than comparing
// a `.normal`-state format against a `.selected`-state format. Both calls compute the `.selected`
// branch's non-image fields from value-identical style data (styleB is a copy of styleA with only
// the images swapped), so those fields are guaranteed to already agree with whatever
// `self.format` holds by the second call. The SECOND call's redundant re-apply can therefore only
// disagree with `self.format` on the image fields -- exactly the variable this fix stops comparing.
// This avoids depending on undocumented assumptions about `Base.default`'s per-state uniformity
// (an assumption the sibling XDNS-0015 suite makes explicitly for `.DNSForm.default`; this suite
// does not need to make it for `.Base.default`).
//
// IMAGE-INSTANCE-CHURN DESIGN NOTE: rather than relying on `DNSThemeFieldStyle`'s internal
// `.copy()` call on UIImage to reliably allocate a new instance, this suite explicitly assigns
// FRESH, SEPARATELY-CONSTRUCTED UIImage instances (same systemName, therefore visually identical,
// but distinct object identity) to the second style's visibleOnImage/visibleOffImage. This
// deterministically reproduces "instance churn, same visual content" without depending on UIKit's
// unspecified copy-on-immutable-object behavior.
//
// COMPILE-TIME CONSTRAINT (verified; a sibling agent lost ~35 minutes to this): DNSUIAnimatedField
// subclasses AnimatedField 3.2.2's `@MainActor open class` (see XDNS-0013), so under this Swift 6
// toolchain every `sut`/`field` access from a nonisolated XCTestCase method is an isolation
// violation, and XCTAssert's autoclosure argument is itself nonisolated -- so this suite MUST be
// `@MainActor` or assertions referencing `field.isFirstResponder` etc. will not type-check.
//
// FIRST-RESPONDER OBSERVABLE CAVEAT: AnimatedField (the third-party base class of
// DNSUIAnimatedField) does NOT override `canBecomeFirstResponder`, so
// `becomeFirstResponder()`'s OWN RETURN VALUE is UIView's default (always false) and is NOT
// meaningful here. The correct observable -- confirmed by reading AnimatedField's own
// `isFirstResponder` override, which forwards to the wrapped internal UITextField -- is the
// `isFirstResponder` PROPERTY. Every assertion below checks that property, never a
// `becomeFirstResponder()` return value.
//
// EXECUTION STATUS: see the trailing comment block at the end of this file for whether this
// suite compiled and ran under the Xcode 27 toolchain at the time it was written (per
// DNSThemeObjects 1.12.4 RELNOTES, `DNSThemeObjectsTests` was known not to compile at all,
// tracked as XDNS-0013), and whether a fail-before/pass-after transition was actually observed
// or only reasoned about.
@MainActor
final class XDNS0018GuardSeamTests: XCTestCase {

    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        // A live, key window is required for the wrapped UITextField's becomeFirstResponder() to
        // succeed at all -- without this every case (guarded or not) fails to focus for reasons
        // unrelated to the defect, which would make every assertion below vacuous.
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        window.isHidden = true
        window = nil
        super.tearDown()
    }

    private func makeField() -> DNSUIAnimatedField {
        let mockCoder = NSKeyedUnarchiver(forReadingWith: Data())
        // swiftlint:disable:next force_unwrapping
        let field = DNSUIAnimatedField(coder: mockCoder)!
        field.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        window.addSubview(field)
        window.layoutIfNeeded()
        return field
    }

    /// Builds `styleA` (the shared `.Base.default` singleton) and `styleB`, a value copy of
    /// `styleA` produced the same way a cell reconfigure would (`DNSThemeFieldStyle(from:)`),
    /// then forces `styleB`'s visibleOnImage/visibleOffImage to fresh, distinct UIImage instances
    /// with the SAME systemName (so visually identical, but never `===` to styleA's). This
    /// isolates image-instance identity as the ONLY state-comparable difference between the two
    /// styles -- confirmed by the `isDiffFrom` precondition below, which mirrors the XDNS-0014
    /// guard's own exclusion of these fields.
    private func makeImageChurnedStylePair() -> (styleA: DNSThemeFieldStyle, styleB: DNSThemeFieldStyle) {
        let styleA = DNSThemeFieldStyle.Base.default
        let styleB = DNSThemeFieldStyle(from: styleA)
        styleB.visibleOnImage = UIImage(systemName: "eye") ?? styleB.visibleOnImage
        styleB.visibleOffImage = UIImage(systemName: "eye.slash") ?? styleB.visibleOffImage

        XCTAssertFalse(styleA.visibleOnImage === styleB.visibleOnImage,
                       "Precondition: visibleOnImage instances must differ -- otherwise this pair " +
                       "does not exercise instance churn at all")
        XCTAssertFalse(styleA.visibleOffImage === styleB.visibleOffImage,
                       "Precondition: visibleOffImage instances must differ")
        XCTAssertFalse(styleA.isDiffFrom(styleB),
                       "Precondition: styleA and styleB must compare equal via isDiffFrom (matching " +
                       "the XDNS-0014 guard's own exclusion of the image fields) -- if this fails, " +
                       "the pair no longer isolates image-instance churn as the sole difference and " +
                       "the guard-effect assertions below would be testing something else entirely")

        return (styleA, styleB)
    }

    // MARK: - Positive control

    /// Standalone sanity check, independent of the guard entirely: if this fails, the harness
    /// itself is not wired up (no live window, etc.) and every guard-effect assertion below would
    /// be vacuous regardless of outcome.
    func test_positiveControl_becomeFirstResponder_actuallyAcquiresFocus() {
        let field = makeField()
        let (styleA, _) = makeImageChurnedStylePair()
        field.style = styleA

        XCTAssertFalse(field.isFirstResponder, "Sanity: freshly styled field must not start focused")

        _ = field.becomeFirstResponder()

        XCTAssertTrue(field.isFirstResponder,
                      "Positive control: field must actually acquire first-responder status -- if " +
                      "this fails, the harness is not wired up and later assertions are vacuous")
    }

    // MARK: - Guard-effect: image-instance churn alone must not resign first responder
    //         (THE XDNS-0018 REGRESSION CHECK)

    func test_focusedField_stateReapplyWithChurnedImageInstances_focusSurvives() {
        let field = makeField()
        let (styleA, styleB) = makeImageChurnedStylePair()

        // Establish a stable baseline `self.format` for the `isSelected == true` branch using
        // styleA, BEFORE focus is acquired and BEFORE any image churn is introduced.
        field.style = styleA
        field.isSelected = true

        _ = field.becomeFirstResponder()
        XCTAssertTrue(field.isFirstResponder,
                      "Positive control: field must be focused before the guard can be meaningfully exercised")

        // The XDNS-0014 guard (isDiffFrom excluding the image fields) makes this assignment a
        // no-op for utilityApply/updateForState -- `self.style` silently becomes styleB while
        // `self.format` is untouched. This is step 3 of the seam: style and format desync.
        field.style = styleB

        // Re-trigger updateForState(using:) with the SAME isSelected state as the baseline above
        // (production analogue: the wrapped UITextField's isSelected/isHighlighted toggling while
        // focused, DNSUIAnimatedField.swift:86-94). Per the isolation technique documented in this
        // file's header, this re-apply's non-image fields are guaranteed to already agree with
        // `self.format` -- ONLY the churned image instances can disagree.
        field.isSelected = true

        XCTAssertTrue(field.isFirstResponder,
                      "XDNS-0018 regression: focus must survive a state-driven format re-apply whose " +
                      "ONLY difference from the currently-applied format is UIImage INSTANCE identity " +
                      "on visibleOnImage/visibleOffImage. Before this fix, dnsHasSameStateValues " +
                      "compared these fields and reported \"different\" purely from instance churn, " +
                      "forcing self.format = newFormat, which resigns first responder via " +
                      "AnimatedField's format.didSet -> setupTitle() rebuild")
    }

    // MARK: - Guard-effect: repeated redundant re-applies with churned image instances

    func test_focusedField_repeatedStateReapplyWithChurnedImageInstances_focusSurvivesEachTime() {
        let field = makeField()
        let (styleA, styleB) = makeImageChurnedStylePair()

        field.style = styleA
        field.isSelected = true

        _ = field.becomeFirstResponder()
        XCTAssertTrue(field.isFirstResponder,
                      "Positive control: field must be focused before the guard can be meaningfully exercised")

        field.style = styleB

        field.isSelected = true
        XCTAssertTrue(field.isFirstResponder, "Focus must survive the 1st image-churned re-apply (isSelected)")

        field.isHighlighted = true
        XCTAssertTrue(field.isFirstResponder, "Focus must survive the 2nd image-churned re-apply (isHighlighted)")

        field.isSelected = true
        XCTAssertTrue(field.isFirstResponder, "Focus must survive the 3rd image-churned re-apply (isSelected)")
    }
}

// EXECUTION STATUS (XDNS-0018-007) -- THIS SUITE HAS NEVER BEEN COMPILED OR RUN.
//
// `xcodebuild test -scheme DNSThemeObjects -only-testing:DNSThemeObjectsTests/XDNS0018GuardSeamTests`
// was attempted against the working tree containing the uncommitted AnimatedField+dnsApplyStyle.swift
// fix, using an isolated -derivedDataPath under the scratchpad to avoid colliding with other
// concurrent xcodebuild processes on this machine (several were already running; a cold build had
// separately taken 13+ minutes without finishing per this subitem's brief). The attempt was
// terminated after ~2 minutes of wall-clock time in which it had only compiled third-party SPM
// dependencies (Alamofire, PhoneNumberKit, SwiftMaskTextfield, SwipeCellKit, ...) -- it never
// reached DNSThemeTypes, DNSThemeObjects, or DNSThemeObjectsTests compilation, produced no error,
// no BUILD FAILED/SUCCEEDED, and no TEST EXECUTE line. This is a genuinely inconclusive "did not
// finish," NOT a confirmed compile failure and NOT a confirmed compile success.
//
// Consequently: this suite's compilation status under the Xcode 27 toolchain is UNCONFIRMED by
// execution. Per DNSThemeObjects 1.12.4 RELNOTES ("Known Problems"), DNSThemeObjectsTests does not
// compile under the Xcode 27 / iOS 27 SDK toolchain at all (tracked as XDNS-0013) -- that
// documented blocker was NOT independently re-verified or re-falsified by this attempt either,
// since the build never got far enough to reach this target.
//
// No fail-before-fix / pass-after-fix transition was observed. None was attempted, because the
// suite was never confirmed to compile in the first place. Every claim in this file's header
// comment about what the guard does and why the assertions are correct is derived from reading
// AnimatedField+dnsApplyStyle.swift, DNSUIAnimatedField.swift, and DNSThemeFieldStyle.swift
// directly (see the file header), NOT from an observed test run. Treat this suite exactly as
// XDNS-0015 shipped: a regression test that is correct on inspection and will run the moment
// XDNS-0013 is resolved, but carries zero runtime verification today.
