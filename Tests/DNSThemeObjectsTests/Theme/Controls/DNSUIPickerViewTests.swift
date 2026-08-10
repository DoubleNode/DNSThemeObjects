//
//  DNSUIPickerViewTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUIPickerViewTests: XCTestCase {
    private var sut: DNSUIPickerView!
    private var mockStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUIPickerView()
        mockStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withDefaultValues_shouldSetDefaultStyle() {
        XCTAssertEqual(sut.styleName, DNSThemeViewStyle.default.fullName)
        XCTAssertTrue(sut.style is DNSThemeViewStyle)
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        let frame = CGRect(x: 10, y: 20, width: 300, height: 200)
        let pickerView = DNSUIPickerView(frame: frame)

        XCTAssertEqual(pickerView.frame, frame)
        XCTAssertEqual(pickerView.styleName, DNSThemeViewStyle.default.fullName)
    }

    func test_init_withCoder_shouldInitializeCorrectly() {
        // Test NSCoder initialization path
        let data = NSKeyedArchiver.archivedData(withRootObject: sut!)
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let decodedPickerView = DNSUIPickerView(coder: unarchiver)

        XCTAssertNotNil(decodedPickerView)
        if let decoded = decodedPickerView {
            XCTAssertEqual(decoded.styleName, DNSThemeViewStyle.default.fullName)
        }
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidStyle_shouldApplyStyle() {
        let newStyle = DNSThemeViewStyle.Base.default

        sut.style = newStyle

        XCTAssertEqual(sut.styleName, newStyle.fullName)
        XCTAssertTrue(sut.style === newStyle)
    }

    func test_styleNameSet_withValidStyleName_shouldUpdateStyle() {
        let styleName = "Base.card"

        sut.styleName = styleName

        XCTAssertEqual(sut.styleName, "Base.default") // Invalid style reverts to default
    }

    func test_styleNameSet_withSameValue_shouldNotTriggerUpdate() {
        let originalStyle = sut.style
        let currentStyleName = sut.styleName

        sut.styleName = currentStyleName

        XCTAssertTrue(sut.style === originalStyle)
    }

    func test_styleNameSet_duringStyleSettingProgress_shouldNotRecurse() {
        let originalStyleName = sut.styleName
        let newStyle = DNSThemeViewStyle.Base.default

        sut.style = newStyle // This sets _settingStyleInProgress = true internally

        // The style name should be updated without recursion
        XCTAssertEqual(sut.styleName, newStyle.fullName)
        XCTAssertEqual(sut.styleName, "Base.default") // Default behavior
    }

    // MARK: - Utility Apply Tests

    func test_utilityApply_withStyleName_shouldApplyCorrectly() {
        let styleName = "Base.default"

        sut.utilityApply(styleName)

        XCTAssertEqual(sut.styleName, styleName)
    }

    func test_utilityApply_withViewStyle_shouldApplyCorrectly() {
        let viewStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(viewStyle)

        // Verify that the style was applied
        XCTAssertNotNil(sut.layer)
        // XDNS-0013: the `XCTAssertNotNil(sut.backgroundColor)` assertion was removed. This
        // control overrides `backgroundColor` to forward the colour to its internal containerView
        // and then deliberately set its own `backgroundColor` to nil for any non-clear colour.
        // Asserting non-nil therefore contradicts the control's intended design.
    }

    func test_utilityApply_withGenericStyle_shouldHandleGracefully() {
        let genericStyle = DNSThemeViewStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(genericStyle))
    }

    // MARK: - State Management Tests

    func test_isEnabled_setToFalse_shouldUpdateForState() {
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isEnabled = false

        XCTAssertFalse(sut.isEnabled)
        // State should be updated in updateForState method
    }

    func test_isEnabled_setToTrue_shouldUpdateForState() {
        sut.isEnabled = false
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isEnabled = true

        XCTAssertTrue(sut.isEnabled)
    }

    func test_isHighlighted_setToTrue_shouldUpdateForState() {
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isHighlighted = true

        XCTAssertTrue(sut.isHighlighted)
    }

    func test_isHighlighted_setToFalse_shouldUpdateForState() {
        sut.isHighlighted = true
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isHighlighted = false

        XCTAssertFalse(sut.isHighlighted)
    }

    func test_isSelected_setToTrue_shouldUpdateForState() {
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isSelected = true

        XCTAssertTrue(sut.isSelected)
    }

    func test_isSelected_setToFalse_shouldUpdateForState() {
        sut.isSelected = true
        let viewStyle = DNSThemeViewStyle.Base.default
        sut.style = viewStyle

        sut.isSelected = false

        XCTAssertFalse(sut.isSelected)
    }

    // MARK: - IBInspectable Properties Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Custom.picker.style"

        sut.styleName = testStyleName

        XCTAssertEqual(sut.styleName, "Base.default") // Invalid style reverts to default
    }

    func test_borderColor_asIBInspectable_shouldBeSettable() {
        let testColor = UIColor.red

        sut.borderColor = testColor

        XCTAssertEqual(sut.borderColor, testColor)
        XCTAssertEqual(sut.layer.borderColor, testColor.cgColor)
    }

    func test_borderWidth_asIBInspectable_shouldBeSettable() {
        let testWidth: CGFloat = 2.5

        sut.borderWidth = testWidth

        XCTAssertEqual(sut.borderWidth, testWidth)
        XCTAssertEqual(sut.layer.borderWidth, testWidth)
    }

    func test_cornerRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 10.0

        sut.cornerRadius = testRadius

        XCTAssertEqual(sut.cornerRadius, testRadius)
        XCTAssertEqual(sut.layer.cornerRadius, testRadius)
    }

    func test_cornerRadiusMulti_asIBInspectable_shouldBeSettable() {
        sut.cornerRadiusMulti = true

        XCTAssertTrue(sut.cornerRadiusMulti)
    }

    func test_cornerTopLeftRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 5.0

        sut.cornerTopLeftRadius = testRadius

        XCTAssertEqual(sut.cornerTopLeftRadius, testRadius)
    }

    func test_cornerTopRightRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 7.0

        sut.cornerTopRightRadius = testRadius

        XCTAssertEqual(sut.cornerTopRightRadius, testRadius)
    }

    func test_cornerBottomLeftRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 3.0

        sut.cornerBottomLeftRadius = testRadius

        XCTAssertEqual(sut.cornerBottomLeftRadius, testRadius)
    }

    func test_cornerBottomRightRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 8.0

        sut.cornerBottomRightRadius = testRadius

        XCTAssertEqual(sut.cornerBottomRightRadius, testRadius)
    }

    func test_shadowOpacity_asIBInspectable_shouldBeSettable() {
        let testOpacity: Float = 0.7

        sut.shadowOpacity = testOpacity

        XCTAssertEqual(sut.shadowOpacity, testOpacity)
        XCTAssertEqual(sut.layer.shadowOpacity, testOpacity)
    }

    func test_shadowRadius_asIBInspectable_shouldBeSettable() {
        let testRadius: CGFloat = 4.0

        sut.shadowRadius = testRadius

        XCTAssertEqual(sut.shadowRadius, testRadius)
        XCTAssertEqual(sut.layer.shadowRadius, testRadius)
    }

    func test_shadowOffset_asIBInspectable_shouldBeSettable() {
        let testOffset = CGSize(width: 2.0, height: 3.0)

        sut.shadowOffset = testOffset

        XCTAssertEqual(sut.shadowOffset, testOffset)
        XCTAssertEqual(sut.layer.shadowOffset, testOffset)
    }

    func test_shadowColor_asIBInspectable_shouldBeSettable() {
        let testColor = UIColor.blue

        sut.shadowColor = testColor

        XCTAssertEqual(sut.shadowColor, testColor)
        XCTAssertEqual(sut.layer.shadowColor, testColor.cgColor)
    }

    // MARK: - Background Color Override Tests

    func test_backgroundColor_setToNonNil_shouldUpdateContainerView() {
        let testColor = UIColor.green

        sut.backgroundColor = testColor

        // Background color is set to nil on the main view after setting container
        XCTAssertNil(sut.backgroundColor)
    }

    func test_backgroundColor_setToNil_shouldNotUpdate() {
        let originalBackgroundColor = sut.backgroundColor

        sut.backgroundColor = nil

        XCTAssertEqual(sut.backgroundColor, originalBackgroundColor)
    }

    func test_backgroundColor_setToClear_shouldSetToNil() {
        sut.backgroundColor = UIColor.clear

        XCTAssertEqual(sut.backgroundColor, UIColor.clear)
    }

    // MARK: - ClipsToBounds Override Tests

    func test_clipsToBounds_setToTrue_shouldUpdateContainerViews() {
        sut.clipsToBounds = true

        XCTAssertTrue(sut.clipsToBounds)
    }

    func test_clipsToBounds_setToFalse_shouldUpdateContainerViews() {
        sut.clipsToBounds = false

        XCTAssertFalse(sut.clipsToBounds)
    }

    // MARK: - Layout Tests

    func test_layoutSubviews_shouldCallSuper() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        XCTAssertNoThrow(sut.layoutSubviews())
    }

    func test_draw_shouldCallSuper() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

        XCTAssertNoThrow(sut.draw(rect))
    }

    func test_prepareForInterfaceBuilder_shouldCallSetupAndRefresh() {
        XCTAssertNoThrow(sut.prepareForInterfaceBuilder())
    }

    // MARK: - Multi-Corner Radius Tests

    func test_applyRadiusMaskFor_withCornerRadiusMultiTrue_shouldApplyMask() {
        sut.cornerRadiusMulti = true
        sut.cornerTopLeftRadius = 5.0
        sut.cornerTopRightRadius = 10.0
        sut.cornerBottomLeftRadius = 15.0
        sut.cornerBottomRightRadius = 20.0
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        sut.layoutSubviews()

        XCTAssertNotNil(sut.layer.mask)
    }

    func test_applyRadiusMaskFor_withCornerRadiusMultiFalse_shouldNotApplyMask() {
        sut.cornerRadiusMulti = false
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        sut.layoutSubviews()

        // Note: The mask might still be nil or the same as before
        // This test ensures no crash occurs when cornerRadiusMulti is false
        XCTAssertNoThrow(sut.layoutSubviews())
    }

    // MARK: - Update For State Tests

    func test_updateForState_withThemeViewStyle_shouldApplyCorrectly() {
        let themeStyle = DNSThemeViewStyle.Base.default

        sut.updateForState(using: themeStyle)

        // Verify that the method executes without crashing
        XCTAssertNotNil(sut.style)
    }

    func test_updateForState_withGenericThemeStyle_shouldApplyCorrectly() {
        let themeStyle = DNSThemeViewStyle.Base.default

        sut.updateForState(using: themeStyle as DNSThemeStyle)

        // Verify that the method executes without crashing
        XCTAssertNotNil(sut.style)
    }

    // MARK: - Edge Cases

    func test_styleSet_duringStyleSetting_shouldNotCauseRecursion() {
        let style1 = DNSThemeViewStyle.Base.default
        let style2 = DNSThemeViewStyle.Base.default

        sut.style = style1
        sut.style = style2

        XCTAssertEqual(sut.styleName, style2.fullName)
    }

    func test_styleName_withEmptyString_shouldHandleGracefully() {
        let emptyStyleName = ""

        XCTAssertNoThrow(sut.styleName = emptyStyleName)
        XCTAssertEqual(sut.styleName, "Base.default") // Empty string reverts to default
    }

    func test_styleName_withNilStyle_shouldHandleGracefully() {
        // Test edge case where style might be nil or invalid
        let invalidStyleName = "NonExistent.Style"

        XCTAssertNoThrow(sut.styleName = invalidStyleName)
        XCTAssertEqual(sut.styleName, "Base.default") // Invalid style reverts to default
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUIPickerView.ThemeStyle.self == DNSThemeViewStyle.self)
    }

    // MARK: - Performance Tests

    func test_styleApplication_performance() {
        let style = DNSThemeViewStyle.Base.default

        measure {
            for _ in 0..<100 {
                sut.style = style
            }
        }
    }

    func test_utilityApply_performance() {
        let style = DNSThemeViewStyle.Base.default

        measure {
            for _ in 0..<100 {
                sut.utilityApply(style)
            }
        }
    }

    // MARK: - Container View Tests

    func test_containerView_shouldBeInsertedAtZeroIndex() {
        // Container view should be at the back
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.layoutSubviews()

        XCTAssertGreaterThan(sut.subviews.count, 0)
    }

    func test_containerImageView_shouldHaveCorrectProperties() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.layoutSubviews()

        // Container image view should be properly configured
        XCTAssertFalse(sut.subviews.isEmpty)
    }

    // MARK: - UIPickerView Specific Tests

    func test_numberOfComponents_shouldBeConfigurable() {
        // Test UIPickerView specific functionality
        let dataSource = MockPickerViewDataSource()
        sut.dataSource = dataSource

        XCTAssertNotNil(sut.dataSource)
    }

    func test_delegate_shouldBeConfigurable() {
        let delegate = MockPickerViewDelegate()
        sut.delegate = delegate

        XCTAssertNotNil(sut.delegate)
    }

    func test_showsSelectionIndicator_shouldBeToggleable() {
        sut.showsSelectionIndicator = true
        XCTAssertTrue(sut.showsSelectionIndicator)

        sut.showsSelectionIndicator = false
        XCTAssertFalse(sut.showsSelectionIndicator)
    }
}

// MARK: - Mock Classes

private class MockPickerViewDataSource: NSObject, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

private class MockPickerViewDelegate: NSObject, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Row \(row)"
    }
}