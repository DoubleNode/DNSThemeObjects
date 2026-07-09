# DNSThemeObjects Release Notes

All notable changes to DNSThemeObjects are documented here. Versions follow [Semantic Versioning](https://semver.org/).

---

## 1.12.4 — 2026-07-09

**Release Type**
-   BUGFIX

**Issues Resolved**
-   XDNS-0015 — Single-line DNSForm text fields (`DNSFormDetailTextFieldCell`) dropped the keyboard ~0.3s after focus and could not be edited (multi-line and picker fields were unaffected). Root cause: the state-driven style path re-assigned `format` on focus with no idempotency guard. On focus the inner text field's `isSelected`/`isHighlighted` toggle, routing through the `DNSUIAnimatedField` state setters into `updateForState(using:)`, which unconditionally did `self.format = newFormat` → AnimatedField 3.2.2's `format.didSet -> setupTitle()` rebuilt the field and resigned first responder. This is a distinct path from the reconfigure/`style.didSet` guard shipped in 1.12.3 (XDNS-0014), which does not cover focus-time state changes.

**New Features**
-   NONE

**Technical Improvements**
-   Guarded the state-driven format re-apply in `AnimatedField.updateForState(using: DNSThemeFieldStyle)`: `guard !newFormat.dnsHasSameStateValues(as: self.format) else { return }` before `self.format = newFormat`. `AnimatedFieldFormat` is not `Equatable`, so a private helper compares exactly the fields `updateForState` mutates. Because `newFormat` begins as a copy of the current format and only those fields are reassigned, the comparison is complete equality and can never skip a genuine state change; a no-op re-apply (e.g. focusing a `.DNSForm.default` field, whose per-state values all equal `.normal`) now early-returns without rebuilding the field.

**Known Problems**
-   Regression coverage for this specific guard is verified by field-list cross-check + value-level mirror + trace rather than an in-package unit test, because `DNSThemeObjectsTests` does not compile under the Xcode 27 / iOS 27 SDK toolchain (XDNS-0013) and DNSForm does not depend on DNSThemeObjects. A runnable test lands with XDNS-0013.

---

## 1.12.3 — 2026-07-08

**Release Type**
-   BUGFIX

**Issues Resolved**
-   XDNS-0014 — DNSForm field cells rendered correctly after the XDNS-0012 fix but were **uneditable**: tapping a field showed the keyboard, which was then immediately dismissed. Root cause: `DNSUIAnimatedField.style.didSet` re-applied the style on every assignment (its idempotency guard had been commented out since the control's first commit). When a host reconfigured a visible cell while it was first responder (normal `UICollectionView` diffable-datasource behavior), the redundant re-apply rebuilt the field via AnimatedField 3.1.1+'s `format.didSet -> setupTitle()`, resigning first responder. Surfaced only after XDNS-0012 aligned to AnimatedField 3.2.2, where field rebuild moved into `format.didSet`.

**New Features**
-   NONE

**Technical Improvements**
-   Re-enabled the idempotency guard `guard oldValue != style else { return }` in `DNSUIAnimatedField.style.didSet`. The comparison is value-based (`!=` dispatches to `DNSThemeStyle`/`DNSThemeFieldStyle.isDiffFrom`, comparing `titleAlwaysVisible`, `lineColor`, `textStyle`, `titleStyle`, etc.), so it no-ops only genuinely-redundant reassignments while still applying real changes — including the per-cell `titleAlwaysVisible` overrides introduced in DNSForm 1.12.5. State-driven restyling is unaffected: `isEnabled`/`isSelected`/`isHighlighted` call `updateForState(using:)` directly, independent of the style setter.

**Known Problems**
-   The `DNSThemeObjectsTests` unit-test target still does not compile under the Xcode 27 / iOS 27 SDK toolchain (Swift 6 `@MainActor` strict-concurrency). Test-only; the shippable library builds cleanly. Tracked as XDNS-0013. This fix's regression tests were added to the DNSForm test target (which runs) and pass.

---

## 1.12.2 — 2026-07-07

**Release Type**
-   MAINTENANCE

**Issues Resolved**
-   XDNS-0012 — Aligned the AnimatedField dependency to 3.2.2 to match the version resolved by downstream apps. AnimatedField 3.1.1+ moved title/text-field setup into `format.didSet -> setupTitle()`; building and validating against 3.2.2 ensures the DNS style path (`AnimatedField+dnsApplyStyle.swift`) drives the field format correctly on the version apps actually ship. Supports the companion DNSForm field-cell visibility fix.

**New Features**
-   NONE

**Technical Improvements**
-   Bumped `AnimatedField` from `.upToNextMajor(from: "3.0.0")` to `.upToNextMajor(from: "3.2.2")` (transitively pulls `swift-mask-textfield` 1.2.0). No source changes; the existing `dnsApply` / `updateForState` style path already assigns `format` and requires no bridge.

**Known Problems**
-   The `DNSThemeObjectsTests` unit-test target does not compile under the Xcode 27 / iOS 27 SDK toolchain due to Swift 6 strict-concurrency (`@MainActor`) checking on UIKit and AnimatedField 3.2.2. This is test-only, pre-existing toolchain tech debt — the shippable library builds cleanly and consumers are unaffected. Tracked separately for Swift 6 test-suite readiness.

---
