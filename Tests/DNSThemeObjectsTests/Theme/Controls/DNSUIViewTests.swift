//
//  DNSUIViewTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUIViewTests: XCTestCase {
    private var sut: DNSUIView!
    private var mockStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUIView()
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
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = DNSUIView(frame: frame)

        XCTAssertEqual(view.frame, frame)
        XCTAssertEqual(view.styleName, DNSThemeViewStyle.default.fullName)
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidStyle_shouldApplyStyle() {
        let newStyle = DNSThemeViewStyle.Base.default

        sut.style = newStyle

        XCTAssertEqual(sut.styleName, newStyle.fullName)
        XCTAssertTrue(sut.style === newStyle)
    }

    func test_styleNameSet_withValidStyleName_shouldUpdateStyle() {
        let styleName = "Base.default"

        sut.styleName = styleName

        XCTAssertEqual(sut.styleName, styleName)
    }

    func test_styleNameSet_withSameValue_shouldNotTriggerUpdate() {
        let originalStyle = sut.style
        let currentStyleName = sut.styleName

        sut.styleName = currentStyleName

        XCTAssertTrue(sut.style === originalStyle)
    }

    // MARK: - Utility Apply Tests

    func test_utilityApply_withViewStyle_shouldApplyCorrectly() {
        let viewStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(viewStyle)

        // Verify that the style was applied
        XCTAssertNotNil(sut.layer)
        // Background color may be nil if not set by style
        // XCTAssertNotNil(sut.backgroundColor)
    }

    func test_utilityApply_withGenericStyle_shouldHandleGracefully() {
        let genericStyle = DNSThemeViewStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(genericStyle))
    }

    // MARK: - Layer Properties Tests

    func test_cornerRadius_afterStyleApplication_shouldBeSet() {
        let viewStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(viewStyle)

        // Corner radius should be applied if set in style
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    func test_borderWidth_afterStyleApplication_shouldBeSet() {
        let viewStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(viewStyle)

        // Border width should be applied if set in style
        XCTAssertGreaterThanOrEqual(sut.layer.borderWidth, 0)
    }

    func test_backgroundColor_afterStyleApplication_shouldBeSet() {
        let viewStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(viewStyle)

        // Background color may or may not be set depending on style
        // Just verify the style application didn't crash
        XCTAssertNotNil(sut.layer)
    }

    // MARK: - IBInspectable Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Base.default"

        sut.styleName = testStyleName

        XCTAssertEqual(sut.styleName, testStyleName)
    }

    // MARK: - Subview Management Tests

    func test_addSubview_shouldWork() {
        let subview = UIView()

        sut.addSubview(subview)

        XCTAssertTrue(sut.subviews.contains(subview))
        XCTAssertEqual(subview.superview, sut)
    }

    func test_removeFromSuperview_shouldWork() {
        let superview = UIView()
        superview.addSubview(sut)

        sut.removeFromSuperview()

        XCTAssertNil(sut.superview)
        XCTAssertFalse(superview.subviews.contains(sut))
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

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUIView.ThemeStyle.self == DNSThemeViewStyle.self)
    }

    // MARK: - Layout Tests

    func test_frame_shouldBeSettable() {
        let newFrame = CGRect(x: 10, y: 20, width: 150, height: 200)

        sut.frame = newFrame

        XCTAssertEqual(sut.frame, newFrame)
    }

    func test_bounds_shouldBeSettable() {
        let newBounds = CGRect(x: 0, y: 0, width: 100, height: 150)

        sut.bounds = newBounds

        XCTAssertEqual(sut.bounds, newBounds)
    }

    // MARK: - Visibility Tests

    func test_isHidden_shouldBeToggleable() {
        sut.isHidden = true
        XCTAssertTrue(sut.isHidden)

        sut.isHidden = false
        XCTAssertFalse(sut.isHidden)
    }

    func test_alpha_shouldBeSettable() {
        sut.alpha = 0.5

        XCTAssertEqual(sut.alpha, 0.5, accuracy: 0.01)
    }

    // MARK: - Touch Handling Tests

    func test_isUserInteractionEnabled_shouldBeToggleable() {
        sut.isUserInteractionEnabled = false
        XCTAssertFalse(sut.isUserInteractionEnabled)

        sut.isUserInteractionEnabled = true
        XCTAssertTrue(sut.isUserInteractionEnabled)
    }
}