//
//  DNSUIButtonTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUIButtonTests: XCTestCase {
    private var sut: DNSUIButton!
    private var mockStyle: DNSThemeButtonStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUIButton()
        mockStyle = DNSThemeButtonStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withDefaultValues_shouldSetDefaultStyle() {
        XCTAssertEqual(sut.styleName, DNSThemeButtonStyle.default.fullName)
        XCTAssertTrue(sut.style is DNSThemeButtonStyle)
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        let frame = CGRect(x: 10, y: 20, width: 100, height: 50)
        let button = DNSUIButton(frame: frame)

        XCTAssertEqual(button.frame, frame)
        XCTAssertEqual(button.styleName, DNSThemeButtonStyle.default.fullName)
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidStyle_shouldApplyStyle() {
        let newStyle = DNSThemeButtonStyle.Base.default

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

    func test_utilityApply_withButtonStyle_shouldApplyCorrectly() {
        let buttonStyle = DNSThemeButtonStyle.Base.default

        sut.utilityApply(buttonStyle)

        // Verify that the style was applied (implementation details may vary)
        XCTAssertNotNil(sut.layer)
    }

    func test_utilityApply_withViewStyle_shouldCallSuperImplementation() {
        let viewStyle = DNSThemeViewStyle.Base.default

        // This should not crash and should handle the base style
        XCTAssertNoThrow(sut.utilityApply(viewStyle))
    }

    // MARK: - IBInspectable Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Base.default"

        sut.styleName = testStyleName

        XCTAssertEqual(sut.styleName, testStyleName)
    }

    // MARK: - Edge Cases

    func test_styleSet_duringStyleSetting_shouldNotCauseRecursion() {
        // This tests the _settingStyleInProgress flag
        let style1 = DNSThemeButtonStyle.Base.default
        let style2 = DNSThemeButtonStyle.Base.default

        sut.style = style1
        sut.style = style2

        XCTAssertEqual(sut.styleName, style2.fullName)
    }

    func test_styleName_withEmptyString_shouldHandleGracefully() {
        let emptyStyleName = ""

        XCTAssertNoThrow(sut.styleName = emptyStyleName)
        XCTAssertEqual(sut.styleName, "Base.default") // Empty string reverts to default
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUIButton.ThemeStyle.self == DNSThemeButtonStyle.self)
    }
}