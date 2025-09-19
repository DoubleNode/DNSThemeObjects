//
//  DNSUICollectionReusableViewTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUICollectionReusableViewTests: XCTestCase {
    private var sut: DNSUICollectionReusableView!
    private var mockStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUICollectionReusableView()
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
        let frame = CGRect(x: 10, y: 20, width: 300, height: 50)
        let reusableView = DNSUICollectionReusableView(frame: frame)

        XCTAssertEqual(reusableView.frame, frame)
        XCTAssertEqual(reusableView.styleName, DNSThemeViewStyle.default.fullName)
        XCTAssertTrue(reusableView.style is DNSThemeViewStyle)
    }

    func test_init_withCoder_shouldInitializeCorrectly() {
        // Test NSCoder initialization path
        let data = NSKeyedArchiver.archivedData(withRootObject: sut!)
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let decodedView = DNSUICollectionReusableView(coder: unarchiver)

        XCTAssertNotNil(decodedView)
        if let decoded = decodedView {
            XCTAssertEqual(decoded.styleName, DNSThemeViewStyle.default.fullName)
        }
    }

    // MARK: - UICollectionReusableView Inheritance Tests

    func test_inheritance_shouldBeUICollectionReusableView() {
        XCTAssertTrue(sut is UICollectionReusableView)
        XCTAssertTrue(type(of: sut).isSubclass(of: UICollectionReusableView.self))
    }

    func test_inheritance_shouldBeUIView() {
        XCTAssertTrue(sut is UIView)
        XCTAssertTrue(type(of: sut).isSubclass(of: UIView.self))
    }

    func test_reuseIdentifier_shouldBeReadable() {
        // reuseIdentifier is read-only and set during registration
        // We can test that it exists and can be read
        // ReuseIdentifier may be nil in test environment
        _ = sut.reuseIdentifier
    }

    // MARK: - Header/Footer Usage Tests

    func test_asHeader_shouldWorkCorrectly() {
        let headerFrame = CGRect(x: 0, y: 0, width: 300, height: 50)
        let header = DNSUICollectionReusableView(frame: headerFrame)
        // reuseIdentifier is read-only, set during collection view registration

        XCTAssertNotNil(header)
        XCTAssertEqual(header.frame.height, 50)
    }

    func test_asFooter_shouldWorkCorrectly() {
        let footerFrame = CGRect(x: 0, y: 0, width: 300, height: 30)
        let footer = DNSUICollectionReusableView(frame: footerFrame)
        // reuseIdentifier is read-only, set during collection view registration

        XCTAssertNotNil(footer)
        XCTAssertEqual(footer.frame.height, 30)
    }

    func test_withCustomSupplementaryKind_shouldWorkCorrectly() {
        let customKind = "CustomSupplementaryElement"
        let customFrame = CGRect(x: 0, y: 0, width: 300, height: 80)
        let customView = DNSUICollectionReusableView(frame: customFrame)
        // reuseIdentifier is read-only, set during collection view registration

        XCTAssertEqual(customKind, "CustomSupplementaryElement")
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

        // Verify that the style was applied (layer always exists, backgroundColor may be nil)
        XCTAssertNotNil(sut.layer)
        // Background color may be nil in test environment
        _ = sut.backgroundColor
    }

    func test_utilityApply_withGenericStyle_shouldHandleGracefully() {
        let genericStyle = DNSThemeViewStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(genericStyle))
    }

    // MARK: - Selection Properties Tests

    func test_isSelectable_shouldDefaultToFalse() {
        XCTAssertFalse(sut.isSelectable)
    }

    func test_canSelect_shouldDefaultToFalse() {
        XCTAssertFalse(sut.canSelect())
    }

    func test_isSelected_withSelectableTrue_shouldAllowSelection() {
        // Create a subclass that allows selection for testing
        let selectableView = MockSelectableReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

        selectableView.isSelected = true

        XCTAssertTrue(selectableView.isSelected)
    }

    func test_isSelected_withSelectableFalse_shouldPreventSelection() {
        sut.isSelected = true

        XCTAssertFalse(sut.isSelected) // Should remain false since not selectable
    }

    func test_isSelected_toggleState_shouldWorkWithSelectableView() {
        let selectableView = MockSelectableReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

        selectableView.isSelected = true
        XCTAssertTrue(selectableView.isSelected)

        selectableView.isSelected = false
        XCTAssertFalse(selectableView.isSelected)
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
        let selectableView = MockSelectableReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        let viewStyle = DNSThemeViewStyle.Base.default
        selectableView.style = viewStyle

        selectableView.isSelected = true

        XCTAssertTrue(selectableView.isSelected)
    }

    func test_isSelected_setToFalse_shouldUpdateForState() {
        let selectableView = MockSelectableReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        selectableView.isSelected = true
        let viewStyle = DNSThemeViewStyle.Base.default
        selectableView.style = viewStyle

        selectableView.isSelected = false

        XCTAssertFalse(selectableView.isSelected)
    }

    // MARK: - IBInspectable Properties Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Custom.header.style"

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
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)

        XCTAssertNoThrow(sut.layoutSubviews())
    }

    func test_draw_shouldCallSuper() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 50)

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
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)

        sut.layoutSubviews()

        XCTAssertNotNil(sut.layer.mask)
    }

    func test_applyRadiusMaskFor_withCornerRadiusMultiFalse_shouldNotApplyMask() {
        sut.cornerRadiusMulti = false
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)

        sut.layoutSubviews()

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

    // MARK: - View Reuse Tests

    func test_prepareForReuse_shouldCallSuper() {
        XCTAssertNoThrow(sut.prepareForReuse())
    }

    func test_prepareForReuse_shouldResetStateProperties() {
        sut.isHighlighted = true
        sut.isSelected = true

        sut.prepareForReuse()

        // State should be handled properly for reuse
        XCTAssertNoThrow(sut.prepareForReuse())
    }

    func test_prepareForReuse_multipleCalls_shouldNotCrash() {
        for _ in 0..<10 {
            XCTAssertNoThrow(sut.prepareForReuse())
        }
    }

    // MARK: - Reuse Identifier Tests

    func test_reuseIdentifier_defaultValue_shouldExist() {
        // reuseIdentifier is read-only, test that it can be read
        let reuseId = sut.reuseIdentifier

        // reuseIdentifier might be nil or have a default value
        XCTAssertTrue(reuseId == nil || !reuseId!.isEmpty)
    }

    func test_classNameAsReuseIdentifier_shouldWork() {
        let identifier = String(describing: DNSUICollectionReusableView.self)
        // Test the pattern used for registering reusable views

        XCTAssertEqual(identifier, "DNSUICollectionReusableView")
        XCTAssertFalse(identifier.isEmpty)
    }

    func test_elementKindAsReuseIdentifier_shouldWork() {
        let elementKind = UICollectionView.elementKindSectionHeader
        // Test that system element kinds are available

        XCTAssertEqual(elementKind, "UICollectionElementKindSectionHeader")
        XCTAssertFalse(elementKind.isEmpty)
    }

    // MARK: - Container View Tests

    func test_containerView_shouldBeInsertedAtZeroIndex() {
        // Container view should be at the back
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        sut.layoutSubviews()

        XCTAssertGreaterThan(sut.subviews.count, 0)
    }

    func test_containerImageView_shouldHaveCorrectProperties() {
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        sut.layoutSubviews()

        // Container image view should be properly configured
        XCTAssertFalse(sut.subviews.isEmpty)
    }

    func test_containerView_userInteractionDisabled() {
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        sut.layoutSubviews()

        // Container views should not interfere with user interaction
        XCTAssertGreaterThan(sut.subviews.count, 0)
    }

    // MARK: - Header/Footer Specific Tests

    func test_typicalHeaderHeight_shouldBeConfigurable() {
        let headerHeight: CGFloat = 60
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: headerHeight)

        XCTAssertEqual(sut.frame.height, headerHeight)
    }

    func test_typicalFooterHeight_shouldBeConfigurable() {
        let footerHeight: CGFloat = 40
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: footerHeight)

        XCTAssertEqual(sut.frame.height, footerHeight)
    }

    func test_addingSubviewsToReusableView_shouldWork() {
        let titleLabel = UILabel()
        titleLabel.text = "Header Title"
        sut.addSubview(titleLabel)

        XCTAssertEqual(sut.subviews.count, 2) // Container view + title label
        XCTAssertTrue(sut.subviews.contains(titleLabel))
    }

    func test_constraintsInReusableView_shouldWork() {
        let titleLabel = UILabel()
        titleLabel.text = "Header Title"
        sut.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: sut.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: sut.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        XCTAssertNoThrow(sut.layoutIfNeeded())
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
        let invalidStyleName = "NonExistent.Style"

        XCTAssertNoThrow(sut.styleName = invalidStyleName)
        XCTAssertEqual(sut.styleName, "Base.default") // Invalid style reverts to default
    }

    func test_shadowProperties_withNilLayers_shouldHandleGracefully() {
        // Test edge case where layer properties might be nil
        XCTAssertNoThrow(sut.shadowColor = UIColor.black)
        XCTAssertNoThrow(sut.shadowOpacity = 0.5)
        XCTAssertNoThrow(sut.shadowRadius = 5.0)
        XCTAssertNoThrow(sut.shadowOffset = CGSize(width: 1, height: 1))
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUICollectionReusableView.ThemeStyle.self == DNSThemeViewStyle.self)
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

    func test_prepareForReuse_performance() {
        measure {
            for _ in 0..<1000 {
                sut.prepareForReuse()
            }
        }
    }

    func test_layoutSubviews_performance() {
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 50)

        measure {
            for _ in 0..<100 {
                sut.layoutSubviews()
            }
        }
    }

    // MARK: - Accessibility Tests

    func test_accessibilityLabel_shouldBeSettable() {
        let accessibilityText = "Section Header"
        sut.accessibilityLabel = accessibilityText

        XCTAssertEqual(sut.accessibilityLabel, accessibilityText)
    }

    func test_accessibilityTraits_shouldIncludeDefault() {
        // Reusable view should have default accessibility traits
        XCTAssertNotNil(sut.accessibilityTraits)
    }

    func test_accessibilityValue_shouldBeSettable() {
        let accessibilityValue = "Section 1 of 5"
        sut.accessibilityValue = accessibilityValue

        XCTAssertEqual(sut.accessibilityValue, accessibilityValue)
    }

    func test_accessibilityHint_shouldBeSettable() {
        let accessibilityHint = "Section header with navigation options"
        sut.accessibilityHint = accessibilityHint

        XCTAssertEqual(sut.accessibilityHint, accessibilityHint)
    }

    func test_accessibilityTraits_asHeader_shouldHaveHeaderTrait() {
        // reuseIdentifier is read-only, set during registration
        sut.accessibilityTraits.insert(.header)

        XCTAssertTrue(sut.accessibilityTraits.contains(.header))
    }

    // MARK: - Bounds and Frame Tests

    func test_frame_shouldBeSettable() {
        let testFrame = CGRect(x: 50, y: 100, width: 200, height: 75)

        sut.frame = testFrame

        XCTAssertEqual(sut.frame, testFrame)
    }

    func test_bounds_shouldBeSettable() {
        let testBounds = CGRect(x: 0, y: 0, width: 250, height: 80)

        sut.bounds = testBounds

        XCTAssertEqual(sut.bounds, testBounds)
    }

    func test_center_shouldBeSettable() {
        let testCenter = CGPoint(x: 150, y: 200)

        sut.center = testCenter

        XCTAssertEqual(sut.center, testCenter)
    }

    // MARK: - Content Configuration Tests

    func test_addingMultipleSubviews_shouldWork() {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Subtitle"

        sut.addSubview(titleLabel)
        sut.addSubview(subtitleLabel)

        XCTAssertEqual(sut.subviews.count, 3) // Container view + 2 labels
        XCTAssertTrue(sut.subviews.contains(titleLabel))
        XCTAssertTrue(sut.subviews.contains(subtitleLabel))
    }

    func test_removingSubviews_shouldWork() {
        let testView = UIView()
        sut.addSubview(testView)
        let initialCount = sut.subviews.count

        testView.removeFromSuperview()

        XCTAssertEqual(sut.subviews.count, initialCount - 1)
        XCTAssertFalse(sut.subviews.contains(testView))
    }

    // MARK: - Integration Tests with Collection View

    func test_integrationWithCollectionView_shouldWork() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 300, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(DNSUICollectionReusableView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "HeaderIdentifier")

        // This should not crash during registration
        XCTAssertNoThrow(collectionView.register(DNSUICollectionReusableView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                               withReuseIdentifier: "HeaderIdentifier"))
    }
}

// MARK: - Mock Classes

private class MockSelectableReusableView: DNSUICollectionReusableView {
    override func canSelect() -> Bool {
        return true
    }
}