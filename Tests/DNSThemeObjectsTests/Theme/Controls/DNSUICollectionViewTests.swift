//
//  DNSUICollectionViewTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUICollectionViewTests: XCTestCase {
    private var sut: DNSUICollectionView!
    private var mockStyle: DNSThemeViewStyle!
    private var mockLayout: UICollectionViewFlowLayout!

    override func setUp() {
        super.setUp()
        mockLayout = UICollectionViewFlowLayout()
        sut = DNSUICollectionView(frame: .zero, collectionViewLayout: mockLayout)
        mockStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        mockLayout = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withFrameAndLayout_shouldSetDefaultStyle() {
        let frame = CGRect(x: 10, y: 20, width: 300, height: 400)
        let layout = UICollectionViewFlowLayout()
        let collectionView = DNSUICollectionView(frame: frame, collectionViewLayout: layout)

        XCTAssertEqual(collectionView.frame, frame)
        XCTAssertEqual(collectionView.styleName, DNSThemeViewStyle.default.fullName)
        XCTAssertTrue(collectionView.style is DNSThemeViewStyle)
        XCTAssertEqual(collectionView.collectionViewLayout, layout)
    }

    func test_init_withCoder_shouldInitializeCorrectly() {
        // Test NSCoder initialization path
        let data = NSKeyedArchiver.archivedData(withRootObject: sut!)
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let decodedCollectionView = DNSUICollectionView(coder: unarchiver)

        XCTAssertNotNil(decodedCollectionView)
        if let decoded = decodedCollectionView {
            XCTAssertEqual(decoded.styleName, DNSThemeViewStyle.default.fullName)
        }
    }

    func test_init_withFlowLayout_shouldApplyLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5

        let collectionView = DNSUICollectionView(frame: .zero, collectionViewLayout: layout)

        XCTAssertEqual(collectionView.collectionViewLayout, layout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            XCTAssertEqual(flowLayout.itemSize, CGSize(width: 100, height: 100))
            XCTAssertEqual(flowLayout.minimumLineSpacing, 10)
            XCTAssertEqual(flowLayout.minimumInteritemSpacing, 5)
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

        // If Base.card style doesn't exist, it falls back to default
        XCTAssertEqual(sut.styleName, "Base.default")
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
        // When both styles are Base.default, they will be equal - this tests no crash occurred
        XCTAssertNotNil(sut.styleName)
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
        let testStyleName = "Custom.collectionview.style"

        sut.styleName = testStyleName

        // Custom style names that don't exist fall back to default
        XCTAssertEqual(sut.styleName, "Base.default")
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
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 400)

        XCTAssertNoThrow(sut.layoutSubviews())
    }

    func test_draw_shouldCallSuper() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 400)

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
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 400)

        sut.layoutSubviews()

        XCTAssertNotNil(sut.layer.mask)
    }

    func test_applyRadiusMaskFor_withCornerRadiusMultiFalse_shouldNotApplyMask() {
        sut.cornerRadiusMulti = false
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 400)

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

    // MARK: - UICollectionView Specific Tests

    func test_collectionViewLayout_shouldBeConfigurable() {
        let newLayout = UICollectionViewFlowLayout()
        newLayout.itemSize = CGSize(width: 50, height: 50)

        sut.collectionViewLayout = newLayout

        XCTAssertEqual(sut.collectionViewLayout, newLayout)
        if let flowLayout = sut.collectionViewLayout as? UICollectionViewFlowLayout {
            XCTAssertEqual(flowLayout.itemSize, CGSize(width: 50, height: 50))
        }
    }

    func test_dataSource_shouldBeConfigurable() {
        let dataSource = MockCollectionViewDataSource()

        sut.dataSource = dataSource

        XCTAssertNotNil(sut.dataSource)
        XCTAssertTrue(sut.dataSource === dataSource)
    }

    func test_delegate_shouldBeConfigurable() {
        let delegate = MockCollectionViewDelegate()

        sut.delegate = delegate

        XCTAssertNotNil(sut.delegate)
        XCTAssertTrue(sut.delegate === delegate)
    }

    func test_allowsSelection_shouldBeToggleable() {
        sut.allowsSelection = true
        XCTAssertTrue(sut.allowsSelection)

        sut.allowsSelection = false
        XCTAssertFalse(sut.allowsSelection)
    }

    func test_allowsMultipleSelection_shouldBeToggleable() {
        sut.allowsMultipleSelection = true
        XCTAssertTrue(sut.allowsMultipleSelection)

        sut.allowsMultipleSelection = false
        XCTAssertFalse(sut.allowsMultipleSelection)
    }

    // MARK: - Collection View Cell Registration Tests

    func test_registerCell_withClass_shouldWork() {
        sut.register(MockCollectionViewCell.self, forCellWithReuseIdentifier: "TestCell")

        // No crash should occur during registration
        XCTAssertNoThrow(sut.register(MockCollectionViewCell.self, forCellWithReuseIdentifier: "TestCell"))
    }

    func test_registerCell_withNib_shouldWork() {
        let nib = UINib(nibName: "MockCell", bundle: nil)

        XCTAssertNoThrow(sut.register(nib, forCellWithReuseIdentifier: "NibCell"))
    }

    func test_registerSupplementaryView_withClass_shouldWork() {
        sut.register(MockCollectionReusableView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "Header")

        XCTAssertNoThrow(sut.register(MockCollectionReusableView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "Header"))
    }

    // MARK: - Scroll View Properties Tests

    func test_contentOffset_shouldBeConfigurable() {
        let testOffset = CGPoint(x: 100, y: 200)

        sut.contentOffset = testOffset

        XCTAssertEqual(sut.contentOffset, testOffset)
    }

    func test_contentSize_shouldBeSettable() {
        let testSize = CGSize(width: 1000, height: 2000)

        sut.contentSize = testSize

        XCTAssertEqual(sut.contentSize, testSize)
    }

    func test_scrollEnabled_shouldBeToggleable() {
        sut.isScrollEnabled = true
        XCTAssertTrue(sut.isScrollEnabled)

        sut.isScrollEnabled = false
        XCTAssertFalse(sut.isScrollEnabled)
    }

    func test_showsVerticalScrollIndicator_shouldBeToggleable() {
        sut.showsVerticalScrollIndicator = true
        XCTAssertTrue(sut.showsVerticalScrollIndicator)

        sut.showsVerticalScrollIndicator = false
        XCTAssertFalse(sut.showsVerticalScrollIndicator)
    }

    func test_showsHorizontalScrollIndicator_shouldBeToggleable() {
        sut.showsHorizontalScrollIndicator = true
        XCTAssertTrue(sut.showsHorizontalScrollIndicator)

        sut.showsHorizontalScrollIndicator = false
        XCTAssertFalse(sut.showsHorizontalScrollIndicator)
    }

    // MARK: - Reload Data Tests

    func test_reloadData_shouldWork() {
        let dataSource = MockCollectionViewDataSource()
        sut.dataSource = dataSource

        XCTAssertNoThrow(sut.reloadData())
    }

    func test_reloadSections_shouldWork() {
        let dataSource = MockCollectionViewDataSource()
        sut.dataSource = dataSource
        let indexSet = IndexSet(integer: 0)

        XCTAssertNoThrow(sut.reloadSections(indexSet))
    }

    func test_reloadItems_shouldWork() {
        let dataSource = MockCollectionViewDataSource()
        sut.dataSource = dataSource
        let indexPaths = [IndexPath(item: 0, section: 0)]

        XCTAssertNoThrow(sut.reloadItems(at: indexPaths))
    }

    // MARK: - Selection Tests

    func test_selectItem_shouldWork() {
        let dataSource = MockCollectionViewDataSource()
        sut.dataSource = dataSource
        sut.allowsSelection = true
        let indexPath = IndexPath(item: 0, section: 0)

        XCTAssertNoThrow(sut.selectItem(at: indexPath, animated: false, scrollPosition: []))
    }

    func test_deselectItem_shouldWork() {
        let dataSource = MockCollectionViewDataSource()
        sut.dataSource = dataSource
        sut.allowsSelection = true
        let indexPath = IndexPath(item: 0, section: 0)

        XCTAssertNoThrow(sut.deselectItem(at: indexPath, animated: false))
    }

    func test_indexPathsForSelectedItems_shouldReturnCorrectPaths() {
        let selectedPaths = sut.indexPathsForSelectedItems

        // Initially should be nil or empty
        XCTAssertTrue(selectedPaths?.isEmpty ?? true)
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
        // Empty style names fall back to default
        XCTAssertEqual(sut.styleName, "Base.default")
    }

    func test_styleName_withNilStyle_shouldHandleGracefully() {
        // Test edge case where style might be nil or invalid
        let invalidStyleName = "NonExistent.Style"

        XCTAssertNoThrow(sut.styleName = invalidStyleName)
        // Invalid style names fall back to default
        XCTAssertEqual(sut.styleName, "Base.default")
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUICollectionView.ThemeStyle.self == DNSThemeViewStyle.self)
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

    func test_cellRegistration_performance() {
        measure {
            for i in 0..<100 {
                sut.register(MockCollectionViewCell.self, forCellWithReuseIdentifier: "Cell\(i)")
            }
        }
    }

    // MARK: - Container View Tests

    func test_containerView_shouldBeInsertedAtZeroIndex() {
        // Container view should be at the back
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        sut.layoutSubviews()

        XCTAssertGreaterThan(sut.subviews.count, 0)
    }

    func test_containerImageView_shouldHaveCorrectProperties() {
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        sut.layoutSubviews()

        // Container image view should be properly configured
        XCTAssertFalse(sut.subviews.isEmpty)
    }

    // MARK: - Accessibility Tests

    func test_accessibilityLabel_shouldBeSettable() {
        let accessibilityText = "Collection View"
        sut.accessibilityLabel = accessibilityText

        XCTAssertEqual(sut.accessibilityLabel, accessibilityText)
    }

    func test_accessibilityTraits_shouldIncludeDefault() {
        // Collection view should have default accessibility traits
        XCTAssertNotNil(sut.accessibilityTraits)
    }

    // MARK: - Layout Invalidation Tests

    func test_invalidateLayout_shouldWork() {
        if let layout = sut.collectionViewLayout as? UICollectionViewFlowLayout {
            XCTAssertNoThrow(layout.invalidateLayout())
        }
    }

    func test_setCollectionViewLayout_animated_shouldWork() {
        let newLayout = UICollectionViewFlowLayout()
        newLayout.itemSize = CGSize(width: 80, height: 80)

        XCTAssertNoThrow(sut.setCollectionViewLayout(newLayout, animated: false))
        XCTAssertEqual(sut.collectionViewLayout, newLayout)
    }
}

// MARK: - Mock Classes

private class MockCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

private class MockCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Mock implementation
    }
}

private class MockCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private class MockCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}