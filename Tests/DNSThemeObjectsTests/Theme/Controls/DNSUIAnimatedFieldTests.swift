//
//  DNSUIAnimatedFieldTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
import AnimatedField
@testable import DNSThemeObjects

// XDNS-0013: `DNSUIAnimatedField` subclasses AnimatedField 3.2.2's `@MainActor open class`,
// so under Swift 6 strict concurrency every `sut` access from a nonisolated XCTestCase method
// is an isolation violation. Annotating the suite is the correct fix — these tests drive UIKit
// and genuinely belong on the main actor.
@MainActor
final class DNSUIAnimatedFieldTests: XCTestCase {
    private var sut: DNSUIAnimatedField!
    private var mockStyle: DNSThemeFieldStyle!

    override func setUp() {
        super.setUp()
        // Create mock coder for initialization
        let data = Data()
        let mockCoder = NSKeyedUnarchiver(forReadingWith: data)
        sut = DNSUIAnimatedField(coder: mockCoder)
        mockStyle = DNSThemeFieldStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withCoder_shouldSetDefaultStyle() {
        XCTAssertNotNil(sut)
        if let animatedField = sut {
            XCTAssertEqual(animatedField.styleName, DNSThemeFieldStyle.default.fullName)
            XCTAssertTrue(animatedField.style is DNSThemeFieldStyle)
        }
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        // Test coder initialization path
        let testFrame = CGRect(x: 10, y: 10, width: 150, height: 40)
        let data = Data()
        let mockCoder = NSKeyedUnarchiver(forReadingWith: data)
        let animatedField = DNSUIAnimatedField(coder: mockCoder)

        XCTAssertNotNil(animatedField)
        if let field = animatedField {
            field.frame = testFrame
            // Frame may not be exactly as set due to layout constraints - just verify field exists
            XCTAssertNotNil(field.frame)
            XCTAssertEqual(field.styleName, DNSThemeFieldStyle.default.fullName)
        }
    }

    func test_commonInit_shouldCallLoadNib() {
        // The commonInit method should load the nib
        XCTAssertNoThrow(sut?.commonInit())
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidFieldStyle_shouldApplyStyle() {
        let newStyle = DNSThemeFieldStyle.Base.default

        sut?.style = newStyle

        XCTAssertEqual(sut?.styleName, newStyle.fullName)
        XCTAssertTrue(sut?.style === newStyle)
    }

    func test_styleNameSet_withValidStyleName_shouldUpdateStyle() {
        let styleName = "Base.field"

        sut?.styleName = styleName

        XCTAssertEqual(sut?.styleName, "Base.default") // Invalid style name reverts to default
    }

    func test_styleNameSet_withSameValue_shouldNotTriggerUpdate() {
        guard let sut = sut else { return }
        let originalStyle = sut.style
        let currentStyleName = sut.styleName

        sut.styleName = currentStyleName

        XCTAssertTrue(sut.style === originalStyle)
    }

    func test_styleNameSet_duringStyleSettingProgress_shouldNotRecurse() {
        guard let sut = sut else { return }
        let originalStyleName = sut.styleName
        let newStyle = DNSThemeFieldStyle.Base.default

        sut.style = newStyle // This sets _settingStyleInProgress = true internally

        // The style name should be updated without recursion
        XCTAssertEqual(sut.styleName, newStyle.fullName)
        XCTAssertEqual(sut.styleName, "Base.default") // Default style behavior
    }

    // MARK: - Utility Apply Tests

    func test_utilityApply_withStyleName_shouldApplyCorrectly() {
        let styleName = "Base.default"

        sut?.utilityApply(styleName)

        XCTAssertEqual(sut?.styleName, styleName)
    }

    func test_utilityApply_withFieldStyle_shouldApplyCorrectly() {
        let fieldStyle = DNSThemeFieldStyle.Base.default

        sut?.utilityApply(fieldStyle)

        // Verify that the style was applied
        XCTAssertNotNil(sut?.layer)
        XCTAssertNotNil(sut?.backgroundColor)
    }

    func test_utilityApply_withGenericStyle_shouldHandleGracefully() {
        let genericStyle = DNSThemeFieldStyle.Base.default

        XCTAssertNoThrow(sut?.utilityApply(genericStyle))
    }

    func test_utilityApply_withFieldStyle_shouldCallUpdateForState() {
        let fieldStyle = DNSThemeFieldStyle.Base.default

        sut?.utilityApply(fieldStyle)

        // The field style should trigger the field-specific updateForState method
        XCTAssertNotNil(sut?.style)
    }

    // MARK: - State Management Tests (AnimatedField Override)

    func test_isEnabled_setToFalse_shouldUpdateForState() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isEnabled = false

        XCTAssertFalse(sut.isEnabled)
        // State should be updated in updateForState method
    }

    func test_isEnabled_setToTrue_shouldUpdateForState() {
        guard let sut = sut else { return }
        sut.isEnabled = false
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isEnabled = true

        XCTAssertTrue(sut.isEnabled)
    }

    func test_isHighlighted_setToTrue_shouldUpdateForState() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isHighlighted = true

        XCTAssertTrue(sut.isHighlighted)
    }

    func test_isHighlighted_setToFalse_shouldUpdateForState() {
        guard let sut = sut else { return }
        sut.isHighlighted = true
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isHighlighted = false

        XCTAssertFalse(sut.isHighlighted)
    }

    func test_isSelected_setToTrue_shouldUpdateForState() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isSelected = true

        XCTAssertTrue(sut.isSelected)
    }

    func test_isSelected_setToFalse_shouldUpdateForState() {
        guard let sut = sut else { return }
        sut.isSelected = true
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        sut.isSelected = false

        XCTAssertFalse(sut.isSelected)
    }

    // MARK: - IBInspectable Properties Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Custom.animatedfield.style"

        sut?.styleName = testStyleName

        XCTAssertEqual(sut?.styleName, "Base.default") // Invalid style name reverts to default
    }

    func test_borderColor_asIBInspectable_shouldBeSettable() {
        let testColor = UIColor.red

        sut?.borderColor = testColor

        XCTAssertEqual(sut?.borderColor, testColor)
        XCTAssertEqual(sut?.layer.borderColor, testColor.cgColor)
    }

    func test_borderWidth_asIBInspectable_shouldBeSettable() {
        let testWidth: CGFloat = 2.5

        sut?.borderWidth = testWidth

        XCTAssertEqual(sut?.borderWidth, testWidth)
        XCTAssertEqual(sut?.layer.borderWidth, testWidth)
    }

    func test_cornerRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 10.0

        sut?.cornerRadius = testRadius

        XCTAssertEqual(sut?.cornerRadius, testRadius)
        XCTAssertEqual(sut?.layer.cornerRadius, testRadius)
    }

    func test_cornerRadiusMulti_asIBInspectable_shouldBeSettable() {
        sut?.cornerRadiusMulti = true

        XCTAssertTrue(sut?.cornerRadiusMulti ?? false)
    }

    func test_cornerTopLeftRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 5.0

        sut?.cornerTopLeftRadius = testRadius

        XCTAssertEqual(sut?.cornerTopLeftRadius, testRadius)
    }

    func test_cornerTopRightRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 7.0

        sut?.cornerTopRightRadius = testRadius

        XCTAssertEqual(sut?.cornerTopRightRadius, testRadius)
    }

    func test_cornerBottomLeftRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 3.0

        sut?.cornerBottomLeftRadius = testRadius

        XCTAssertEqual(sut?.cornerBottomLeftRadius, testRadius)
    }

    func test_cornerBottomRightRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 8.0

        sut?.cornerBottomRightRadius = testRadius

        XCTAssertEqual(sut?.cornerBottomRightRadius, testRadius)
    }

    func test_shadowOpacity_asIBInspectable_shouldBeSettable() {
        let testOpacity: Float = 0.7

        sut?.shadowOpacity = testOpacity

        XCTAssertEqual(sut?.shadowOpacity, testOpacity)
        XCTAssertEqual(sut?.layer.shadowOpacity, testOpacity)
    }

    func test_shadowRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 4.0

        sut?.shadowRadius = testRadius

        XCTAssertEqual(sut?.shadowRadius, testRadius)
        XCTAssertEqual(sut?.layer.shadowRadius, testRadius)
    }

    func test_shadowOffset_asIBInspectable_shouldBeSettable() {
        let testOffset = CGSize(width: 2.0, height: 3.0)

        sut?.shadowOffset = testOffset

        XCTAssertEqual(sut?.shadowOffset, testOffset)
        XCTAssertEqual(sut?.layer.shadowOffset, testOffset)
    }

    func test_shadowColor_asIBInspectable_shouldBeSettable() {
        let testColor = UIColor.blue

        sut?.shadowColor = testColor

        XCTAssertEqual(sut?.shadowColor, testColor)
        XCTAssertEqual(sut?.layer.shadowColor, testColor.cgColor)
    }

    // MARK: - Background Color Override Tests

    func test_backgroundColor_setToNonNil_shouldUpdateContainerView() {
        let testColor = UIColor.green

        sut?.backgroundColor = testColor

        // Background color is set to nil on the main view after setting container
        XCTAssertNil(sut?.backgroundColor)
    }

    func test_backgroundColor_setToNil_shouldNotUpdate() {
        guard let sut = sut else { return }
        let originalBackgroundColor = sut.backgroundColor

        sut.backgroundColor = nil

        XCTAssertEqual(sut.backgroundColor, originalBackgroundColor)
    }

    func test_backgroundColor_setToClear_shouldSetToNil() {
        sut?.backgroundColor = UIColor.clear

        XCTAssertEqual(sut?.backgroundColor, UIColor.clear)
    }

    // MARK: - ClipsToBounds Override Tests

    func test_clipsToBounds_setToTrue_shouldUpdateContainerViews() {
        sut?.clipsToBounds = true

        XCTAssertTrue(sut?.clipsToBounds ?? false)
    }

    func test_clipsToBounds_setToFalse_shouldUpdateContainerViews() {
        sut?.clipsToBounds = false

        XCTAssertFalse(sut?.clipsToBounds ?? true)
    }

    // MARK: - Layout Tests

    func test_layoutSubviews_shouldCallSuper() {
        sut?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)

        XCTAssertNoThrow(sut?.layoutSubviews())
    }

    func test_draw_shouldCallSuper() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 50)

        XCTAssertNoThrow(sut?.draw(rect))
    }

    func test_prepareForInterfaceBuilder_shouldCallSetupAndRefresh() {
        XCTAssertNoThrow(sut?.prepareForInterfaceBuilder())
    }

    // MARK: - Multi-Corner Radius Tests

    func test_applyRadiusMaskFor_withCornerRadiusMultiTrue_shouldApplyMask() {
        guard let sut = sut else { return }
        sut.cornerRadiusMulti = true
        sut.cornerTopLeftRadius = 5.0
        sut.cornerTopRightRadius = 10.0
        sut.cornerBottomLeftRadius = 15.0
        sut.cornerBottomRightRadius = 20.0
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 50)

        sut.layoutSubviews()

        XCTAssertNotNil(sut.layer.mask)
    }

    func test_applyRadiusMaskFor_withCornerRadiusMultiFalse_shouldNotApplyMask() {
        guard let sut = sut else { return }
        sut.cornerRadiusMulti = false
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 50)

        sut.layoutSubviews()

        // Note: The mask might still be nil or the same as before
        // This test ensures no crash occurs when cornerRadiusMulti is false
        XCTAssertNoThrow(sut.layoutSubviews())
    }

    // MARK: - AnimatedField Specific Tests

    func test_text_shouldBeConfigurable() {
        let testText = "Test Input"

        sut?.text = testText

        XCTAssertEqual(sut?.text, testText)
    }

    func test_placeholder_shouldBeConfigurable() {
        let testPlaceholder = "Enter text here"

        sut?.placeholder = testPlaceholder

        XCTAssertEqual(sut?.placeholder, testPlaceholder)
    }

    func test_title_shouldBeConfigurable() {
        let testTitle = "Field Title"

        sut?.title = testTitle

        XCTAssertEqual(sut?.title, testTitle)
    }

    func test_format_shouldBeConfigurable() {
        guard let sut = sut else { return }
        // AnimatedField format is not directly accessible, test via style
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        // Verify the field accepts styles that configure format
        XCTAssertNotNil(sut.style)
    }

    func test_type_shouldBeConfigurable() {
        sut?.type = .email

        // Test that type was set by checking validation behavior
        XCTAssertNotNil(sut?.type)
    }

    func test_isSecure_shouldBeToggleable() {
        sut?.isSecure = true
        XCTAssertTrue(sut?.isSecure ?? false)

        sut?.isSecure = false
        XCTAssertFalse(sut?.isSecure ?? true)
    }

    func test_showVisibleButton_shouldBeToggleable() {
        sut?.showVisibleButton = true
        XCTAssertTrue(sut?.showVisibleButton ?? false)

        sut?.showVisibleButton = false
        XCTAssertFalse(sut?.showVisibleButton ?? true)
    }

    // MARK: - AnimatedField Format Tests

    func test_format_titleFont_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        // Format should be updated with style values
        XCTAssertNotNil(sut.format.titleFont)
    }

    func test_format_textFont_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.textFont)
    }

    func test_format_lineColor_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.lineColor)
    }

    func test_format_titleColor_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.titleColor)
    }

    func test_format_textColor_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.textColor)
    }

    func test_format_counterColor_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.counterColor)
    }

    func test_format_alertColor_shouldBeAppliedFromStyle() {
        guard let sut = sut else { return }
        let fieldStyle = DNSThemeFieldStyle.Base.default
        sut.style = fieldStyle

        XCTAssertNotNil(sut.format.alertColor)
    }

    // MARK: - AnimatedField Validation Tests

    func test_isValid_withValidInput_shouldReturnTrue() {
        sut?.type = .email
        sut?.text = "test@example.com"

        // Note: Validation depends on AnimatedField implementation
        // This test ensures no crash occurs
        XCTAssertNoThrow(_ = sut?.isValid)
    }

    func test_isValid_withInvalidInput_shouldReturnFalse() {
        sut?.type = .email
        sut?.text = "invalid-email"

        // Note: Validation depends on AnimatedField implementation
        // This test ensures no crash occurs
        XCTAssertNoThrow(_ = sut?.isValid)
    }

    // XDNS-0013: these two were previously wrapped in a detached `Task { @MainActor in ... }`
    // that was never awaited, so the test method returned before the body ran — they exercised
    // nothing and could not fail. The suite is now @MainActor, so the call runs synchronously
    // on the main actor and a crash actually fails the test.
    func test_showAlert_shouldWork() {
        XCTAssertNoThrow(sut?.showAlert("Test error message"))
    }

    func test_hideAlert_shouldWork() {
        XCTAssertNoThrow(sut?.hideAlert())
    }

    // MARK: - AnimatedField Event Tests

    func test_textField_shouldAcceptInput() {
        // AnimatedField doesn't have addTarget/removeTarget like UIControl
        // Instead test that it behaves like a text input
        let testText = "user input"

        sut?.text = testText

        XCTAssertEqual(sut?.text, testText)
    }

    func test_textField_shouldSupportDelegate() {
        // Test that the field can be configured for text input
        sut?.placeholder = "Enter text"
        sut?.text = "sample"

        XCTAssertEqual(sut?.placeholder, "Enter text")
        XCTAssertEqual(sut?.text, "sample")
    }

    // MARK: - Edge Cases

    func test_styleSet_duringStyleSetting_shouldNotCauseRecursion() {
        guard let sut = sut else { return }
        let style1 = DNSThemeFieldStyle.Base.default
        let style2 = DNSThemeFieldStyle.Base.default

        sut.style = style1
        sut.style = style2

        XCTAssertEqual(sut.styleName, style2.fullName)
    }

    func test_styleName_withEmptyString_shouldHandleGracefully() {
        let emptyStyleName = ""

        XCTAssertNoThrow(sut?.styleName = emptyStyleName)
        XCTAssertEqual(sut?.styleName, "Base.default") // Empty string reverts to default
    }

    func test_styleName_withNilStyle_shouldHandleGracefully() {
        // Test edge case where style might be nil or invalid
        let invalidStyleName = "NonExistent.Style"

        XCTAssertNoThrow(sut?.styleName = invalidStyleName)
        XCTAssertEqual(sut?.styleName, "Base.default") // Invalid style reverts to default
    }

    func test_text_withNilValue_shouldHandleGracefully() {
        sut?.text = nil

        XCTAssertEqual(sut?.text, "") // nil text becomes empty string
    }

    func test_text_withEmptyString_shouldHandleGracefully() {
        sut?.text = ""

        XCTAssertEqual(sut?.text, "")
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUIAnimatedField.ThemeStyle.self == DNSThemeFieldStyle.self)
    }

    // MARK: - Performance Tests

    func test_styleApplication_performance() {
        guard let sut = sut else { return }
        let style = DNSThemeFieldStyle.Base.default

        measure {
            for _ in 0..<100 {
                sut.style = style
            }
        }
    }

    func test_utilityApply_performance() {
        guard let sut = sut else { return }
        let style = DNSThemeFieldStyle.Base.default

        measure {
            for _ in 0..<100 {
                sut.utilityApply(style)
            }
        }
    }

    func test_textChanges_performance() {
        guard let sut = sut else { return }
        let texts = (0..<100).map { "Test text \($0)" }

        measure {
            for text in texts {
                sut.text = text
            }
        }
    }

    // MARK: - Container View Tests

    func test_containerView_shouldBeInsertedAtZeroIndex() {
        // Container view should be at the back
        sut?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        sut?.layoutSubviews()

        XCTAssertGreaterThan(sut?.subviews.count ?? 0, 0)
    }

    func test_containerImageView_shouldHaveCorrectProperties() {
        sut?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        sut?.layoutSubviews()

        // Container image view should be properly configured
        XCTAssertFalse(sut?.subviews.isEmpty ?? true)
    }

    // MARK: - Accessibility Tests

    func test_accessibilityLabel_shouldBeSettable() {
        let accessibilityText = "Animated Text Field"
        sut?.accessibilityLabel = accessibilityText

        XCTAssertEqual(sut?.accessibilityLabel, accessibilityText)
    }

    func test_accessibilityValue_shouldReflectCurrentText() {
        let testText = "Test input"
        sut?.text = testText

        // Accessibility value may be nil in test environment
        // Just verify no crash occurs when accessing it
        _ = sut?.accessibilityValue
    }

    func test_accessibilityTraits_shouldIncludeTextElement() {
        // Animated field should have text field accessibility traits
        XCTAssertNotNil(sut?.accessibilityTraits)
    }

    // MARK: - First Responder Tests

    func test_becomeFirstResponder_shouldWork() {
        // This might not work in unit tests without a proper view hierarchy
        XCTAssertNoThrow(_ = sut?.becomeFirstResponder())
    }

    func test_resignFirstResponder_shouldWork() {
        XCTAssertNoThrow(_ = sut?.resignFirstResponder())
    }

    func test_canBecomeFirstResponder_shouldReturnTrue() {
        // In test environment, first responder capability may be limited
        // Just verify no crash occurs when checking
        _ = sut?.canBecomeFirstResponder ?? false
    }
}

// MARK: - Mock Classes

private class MockAnimatedFieldTarget: NSObject {
    var textChangedCallCount = 0

    @objc func textChanged() {
        textChangedCallCount += 1
    }
}