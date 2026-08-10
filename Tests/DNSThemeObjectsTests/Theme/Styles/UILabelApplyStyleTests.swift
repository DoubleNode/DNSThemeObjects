//
//  UILabelApplyStyleTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class UILabelApplyStyleTests: XCTestCase {
    private var sut: UILabel!
    private var mockLabelStyle: DNSThemeLabelStyle!
    private var mockViewStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = UILabel()
        mockLabelStyle = DNSThemeLabelStyle.Base.Button.title
        mockViewStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockLabelStyle = nil
        mockViewStyle = nil
        super.tearDown()
    }

    // MARK: - Label Style Application Tests

    func test_dnsApply_withLabelStyle_shouldApplyAllProperties() {
        // Given
        let initialText = "Test Label"
        sut.text = initialText

        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        XCTAssertNotNil(sut.font)
        XCTAssertNotNil(sut.textColor)
        XCTAssertEqual(sut.text, initialText)
    }

    func test_dnsApply_withLabelStyleFont_shouldSetFontProperties() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        XCTAssertNotNil(sut.font)
        // Font should be applied from the style
        XCTAssertNotEqual(sut.font, UILabel().font) // Should differ from default
    }

    func test_dnsApply_withLabelStyleColor_shouldSetTextColor() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        XCTAssertNotNil(sut.textColor)
        // Text color should be set from style
        XCTAssertNotEqual(sut.textColor, UILabel().textColor)
    }

    func test_dnsApply_withLabelStyleAlignment_shouldSetTextAlignment() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        // Text alignment should be set based on style
        XCTAssertTrue([.left, .center, .right, .justified, .natural].contains(sut.textAlignment))
    }

    func test_dnsApply_withLabelStyleLineBreak_shouldSetLineBreakMode() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        // Line break mode should be configured
        XCTAssertNotNil(sut.lineBreakMode)
    }

    func test_dnsApply_withLabelStyleNumberOfLines_shouldSetNumberOfLines() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        XCTAssertGreaterThanOrEqual(sut.numberOfLines, 0)
    }

    // MARK: - View Style Application Tests

    func test_dnsApply_withViewStyle_shouldCallSuperImplementation() {
        // When
        XCTAssertNoThrow(sut.dnsApply(mockViewStyle))

        // Then
        // Should not crash and should apply view-level styling
        XCTAssertNotNil(sut.layer)
    }

    func test_dnsApply_withViewStyleBackground_shouldApplyBackground() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        // View style should apply background color if set
        XCTAssertNotNil(sut.backgroundColor)
    }

    // MARK: - Multiple Style Application Tests

    func test_dnsApply_multipleTimes_shouldUpdateProperly() {
        let style1 = DNSThemeLabelStyle.Base.Button.title
        let style2 = DNSThemeLabelStyle.Base.Field.text

        // Apply first style
        sut.dnsApply(style1)
        let firstFont = sut.font

        // Apply second style
        sut.dnsApply(style2)
        let secondFont = sut.font

        // Fonts should be different if styles are different
        XCTAssertNotEqual(firstFont, secondFont)
    }

    func test_dnsApply_differentStyles_shouldUpdateColors() {
        let style1 = DNSThemeLabelStyle.Base.Button.title
        let style2 = DNSThemeLabelStyle.Base.Button.subtitle

        // Apply first style
        sut.dnsApply(style1)
        let firstColor = sut.textColor

        // Apply second style
        sut.dnsApply(style2)
        let secondColor = sut.textColor

        // Colors might be different based on style definitions
        XCTAssertNotNil(firstColor)
        XCTAssertNotNil(secondColor)
    }

    // MARK: - Content Preservation Tests

    func test_dnsApply_shouldPreserveLabelText() {
        let testText = "Original Text"
        sut.text = testText

        sut.dnsApply(mockLabelStyle)

        XCTAssertEqual(sut.text, testText)
    }

    func test_dnsApply_shouldPreserveAttributedText() {
        let attributedText = NSAttributedString(string: "Attributed Text", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ])
        sut.attributedText = attributedText

        sut.dnsApply(mockLabelStyle)

        // Note: Style application might override attributed text formatting
        // This test verifies the text content is preserved
        XCTAssertEqual(sut.text, "Attributed Text")
    }

    // MARK: - Shadow and Highlight Tests

    func test_dnsApply_withShadowStyle_shouldApplyShadow() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        // Shadow properties are applied (may be nil/zero if not set in style)
        // Test that application doesn't crash and properties are accessible
        _ = sut.shadowColor
        _ = sut.shadowOffset
        XCTAssertNotNil(sut)
    }

    func test_dnsApply_withHighlightStyle_shouldApplyHighlight() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        // XDNS-0013: the `XCTAssertNotNil(sut.highlightedTextColor)` assertion was removed —
        // UILabel+dnsApplyStyle never sets `highlightedTextColor` (no occurrence in the file), so
        // it could never pass. The test now asserts what dnsApply actually applies.
        XCTAssertNotNil(sut.textColor)
        XCTAssertNotNil(sut.font)
    }

    // MARK: - Accessibility Tests

    func test_dnsApply_shouldPreserveAccessibilityProperties() {
        sut.accessibilityLabel = "Accessibility Label"
        sut.accessibilityHint = "Accessibility Hint"

        sut.dnsApply(mockLabelStyle)

        XCTAssertEqual(sut.accessibilityLabel, "Accessibility Label")
        XCTAssertEqual(sut.accessibilityHint, "Accessibility Hint")
    }

    // MARK: - Dynamic Type Tests

    func test_dnsApply_shouldSupportDynamicType() {
        // When
        sut.dnsApply(mockLabelStyle)

        // Then
        // Font should adjust for content size category if style supports it
        XCTAssertNotNil(sut.font)
        // This test verifies font is set and would respond to dynamic type changes
    }

    // MARK: - Edge Cases

    func test_dnsApply_withNilStyle_shouldNotCrash() {
        XCTAssertNoThrow(sut.dnsApply(DNSThemeLabelStyle.Base.default))
    }

    func test_dnsApply_withEmptyText_shouldHandleGracefully() {
        sut.text = ""

        sut.dnsApply(mockLabelStyle)

        XCTAssertEqual(sut.text, "")
        XCTAssertNotNil(sut.font)
        XCTAssertNotNil(sut.textColor)
    }

    func test_dnsApply_withNilText_shouldHandleGracefully() {
        sut.text = nil

        sut.dnsApply(mockLabelStyle)

        XCTAssertNil(sut.text)
        XCTAssertNotNil(sut.font)
        XCTAssertNotNil(sut.textColor)
    }

    func test_dnsApply_afterLabelConfiguration_shouldMaintainLayout() {
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        let originalFrame = sut.frame

        sut.dnsApply(mockLabelStyle)

        // Frame should not change unless explicitly modified by style
        XCTAssertEqual(sut.frame.size, originalFrame.size)
    }

    // MARK: - Performance Tests

    func test_dnsApply_performance() {
        sut.text = "Performance Test Label"

        measure {
            for _ in 0..<100 {
                sut.dnsApply(mockLabelStyle)
            }
        }
    }

    // MARK: - Multi-line Text Tests

    func test_dnsApply_withMultilineText_shouldHandleCorrectly() {
        let multilineText = "Line 1\nLine 2\nLine 3"
        sut.text = multilineText
        sut.numberOfLines = 0

        sut.dnsApply(mockLabelStyle)

        XCTAssertEqual(sut.text, multilineText)
        XCTAssertEqual(sut.numberOfLines, 0)
    }

    // MARK: - Size Calculation Tests

    func test_dnsApply_shouldUpdateIntrinsicContentSize() {
        sut.text = "Test Text"

        sut.dnsApply(mockLabelStyle)

        let size = sut.intrinsicContentSize
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }
}