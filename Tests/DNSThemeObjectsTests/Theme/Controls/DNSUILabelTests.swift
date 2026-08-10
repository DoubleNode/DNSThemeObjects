//
//  DNSUILabelTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUILabelTests: XCTestCase {
    private var sut: DNSUILabel!
    private var mockStyle: DNSThemeLabelStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUILabel()
        mockStyle = DNSThemeLabelStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withDefaultValues_shouldSetDefaultStyle() {
        XCTAssertEqual(sut.styleName, DNSThemeLabelStyle.default.fullName)
        XCTAssertTrue(sut.style is DNSThemeLabelStyle)
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        let frame = CGRect(x: 5, y: 10, width: 200, height: 30)
        let label = DNSUILabel(frame: frame)

        XCTAssertEqual(label.frame, frame)
        XCTAssertEqual(label.styleName, DNSThemeLabelStyle.default.fullName)
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidStyle_shouldApplyStyle() {
        let newStyle = DNSThemeLabelStyle.Base.Button.title

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

    // MARK: - Text and Appearance Tests

    func test_text_afterStyleApplication_shouldRetainText() {
        let testText = "Test Label Text"
        sut.text = testText

        sut.style = DNSThemeLabelStyle.Base.Button.title

        XCTAssertEqual(sut.text, testText)
    }

    func test_attributedText_afterStyleApplication_shouldRetainAttributedText() {
        let testAttributedText = NSAttributedString(string: "Attributed Text")
        sut.attributedText = testAttributedText

        sut.style = DNSThemeLabelStyle.Base.Button.subtitle

        // XDNS-0013: was `XCTAssertEqual(sut.attributedText, testAttributedText)`. Applying a style
        // sets font and textColor, which UILabel folds into attributedText as new attributes — so
        // the attributed strings are legitimately no longer equal even though no text was lost.
        // The real contract is that the *string content* survives style application.
        XCTAssertEqual(sut.attributedText?.string, testAttributedText.string)
    }

    // MARK: - Utility Apply Tests

    func test_utilityApply_withLabelStyle_shouldApplyCorrectly() {
        let labelStyle = DNSThemeLabelStyle.Base.Field.text

        sut.utilityApply(labelStyle)

        // Verify that the style was applied
        XCTAssertNotNil(sut.font)
        XCTAssertNotNil(sut.textColor)
    }

    func test_utilityApply_withViewStyle_shouldCallSuperImplementation() {
        let viewStyle = DNSThemeViewStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(viewStyle))
    }

    // MARK: - Accessibility Tests

    func test_accessibilityLabel_shouldBeSettable() {
        let accessibilityText = "Accessibility Label"
        sut.accessibilityLabel = accessibilityText

        XCTAssertEqual(sut.accessibilityLabel, accessibilityText)
    }

    // MARK: - IBInspectable Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Base.default"

        sut.styleName = testStyleName

        XCTAssertEqual(sut.styleName, testStyleName)
    }

    // MARK: - Multiline Text Tests

    func test_numberOfLines_shouldBeConfigurable() {
        sut.numberOfLines = 3

        XCTAssertEqual(sut.numberOfLines, 3)
    }

    func test_lineBreakMode_shouldBeConfigurable() {
        sut.lineBreakMode = .byTruncatingTail

        XCTAssertEqual(sut.lineBreakMode, .byTruncatingTail)
    }

    // MARK: - Edge Cases

    func test_styleSet_duringStyleSetting_shouldNotCauseRecursion() {
        let style1 = DNSThemeLabelStyle.Base.Button.title
        let style2 = DNSThemeLabelStyle.Base.Field.text

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
        XCTAssertTrue(DNSUILabel.ThemeStyle.self == DNSThemeLabelStyle.self)
    }

    // MARK: - Layout Tests

    func test_intrinsicContentSize_withText_shouldReturnValidSize() {
        sut.text = "Test"
        sut.font = UIFont.systemFont(ofSize: 16)

        let size = sut.intrinsicContentSize

        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func test_sizeToFit_withText_shouldUpdateFrame() {
        sut.text = "Test Label"
        sut.font = UIFont.systemFont(ofSize: 16)
        let originalFrame = sut.frame

        sut.sizeToFit()

        XCTAssertNotEqual(sut.frame, originalFrame)
        XCTAssertGreaterThan(sut.frame.width, 0)
        XCTAssertGreaterThan(sut.frame.height, 0)
    }
}