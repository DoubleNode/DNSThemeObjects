//
//  UIButtonApplyStyleTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class UIButtonApplyStyleTests: XCTestCase {
    private var sut: UIButton!
    private var mockButtonStyle: DNSThemeButtonStyle!
    private var mockViewStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = UIButton()
        mockButtonStyle = DNSThemeButtonStyle.Base.default
        mockViewStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockButtonStyle = nil
        mockViewStyle = nil
        super.tearDown()
    }

    // MARK: - Button Style Application Tests

    func test_dnsApply_withButtonStyle_shouldApplyAllProperties() {
        // Given
        let initialTitle = "Test Button"
        sut.setTitle(initialTitle, for: .normal)

        // When
        sut.dnsApply(mockButtonStyle)

        // Then
        XCTAssertNotNil(sut.titleLabel?.font)
        XCTAssertNotNil(sut.titleColor(for: .normal))
        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertEqual(sut.title(for: .normal), initialTitle)
    }

    func test_dnsApply_withButtonStyleColors_shouldSetAllStateColors() {
        // When
        sut.dnsApply(mockButtonStyle)

        // Then
        XCTAssertNotNil(sut.titleColor(for: .normal))
        XCTAssertNotNil(sut.titleColor(for: .highlighted))
        XCTAssertNotNil(sut.titleColor(for: .disabled))
        XCTAssertNotNil(sut.titleColor(for: .selected))
    }

    func test_dnsApply_withButtonStyleFonts_shouldSetFontProperties() {
        // When
        sut.dnsApply(mockButtonStyle)

        // Then
        XCTAssertNotNil(sut.titleLabel?.font)
        // Font should be applied from the style
        XCTAssertNotEqual(sut.titleLabel?.font, UIFont.systemFont(ofSize: 17)) // Default system font
    }

    func test_dnsApply_withButtonStyleBackground_shouldSetBackgroundProperties() {
        // When
        sut.dnsApply(mockButtonStyle)

        // Then
        XCTAssertNotNil(sut.backgroundColor)
        // XDNS-0013: the assertion on backgroundImage(for:) was removed. DNSThemeButtonStyle does
        // not model background images at all (zero occurrences of `backgroundImage` in
        // DNSThemeTypes/Styles/DNSThemeButtonStyle.swift) and UIButton+dnsApplyStyle never calls
        // setBackgroundImage(_:for:) — it styles backgrounds via `backgroundColor` per state.
        // The assertion could therefore never pass; it tested an API the framework deliberately
        // does not use.
    }

    func test_dnsApply_withButtonStyleBorder_shouldSetBorderProperties() {
        // When
        sut.dnsApply(mockButtonStyle)

        // Then
        XCTAssertGreaterThanOrEqual(sut.layer.borderWidth, 0)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
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

    // MARK: - Multiple Application Tests

    func test_dnsApply_multipleTimes_shouldUpdateProperly() {
        let style1 = DNSThemeButtonStyle.Base.default
        let style2 = DNSThemeButtonStyle.Base.default

        // Apply first style
        sut.dnsApply(style1)
        let firstColor = sut.titleColor(for: .normal)

        // Apply second style
        sut.dnsApply(style2)
        let secondColor = sut.titleColor(for: .normal)

        // When applying the same style twice, colors will be the same - test no crash
        XCTAssertNotNil(firstColor)
        XCTAssertNotNil(secondColor)
    }

    // MARK: - Content Preservation Tests

    func test_dnsApply_shouldPreserveButtonTitle() {
        let testTitle = "Original Title"
        sut.setTitle(testTitle, for: .normal)

        sut.dnsApply(mockButtonStyle)

        XCTAssertEqual(sut.title(for: .normal), testTitle)
    }

    func test_dnsApply_shouldPreserveButtonImage() {
        let testImage = createTestImage()
        sut.setImage(testImage, for: .normal)

        sut.dnsApply(mockButtonStyle)

        XCTAssertEqual(sut.image(for: .normal), testImage)
    }

    func test_dnsApply_shouldPreserveTargetActions() {
        let target = self
        let action = #selector(dummyAction)
        sut.addTarget(target, action: action, for: .touchUpInside)

        sut.dnsApply(mockButtonStyle)

        // Actions should still be present
        XCTAssertGreaterThan(sut.allTargets.count, 0)
    }

    // MARK: - State-Specific Tests

    // XDNS-0013: each of these four previously also asserted
    // `XCTAssertNotNil(sut.backgroundImage(for: <state>))`, which could never pass —
    // DNSThemeButtonStyle has no background-image concept and UIButton+dnsApplyStyle never calls
    // setBackgroundImage(_:for:); it styles backgrounds via `backgroundColor`. The per-state
    // titleColor assertions below are the real contract (UIButton+dnsApplyStyle.swift:27-31) and
    // are retained unchanged.
    func test_dnsApply_shouldSetNormalStateProperties() {
        sut.dnsApply(mockButtonStyle)

        XCTAssertNotNil(sut.titleColor(for: .normal))
    }

    func test_dnsApply_shouldSetHighlightedStateProperties() {
        sut.dnsApply(mockButtonStyle)

        XCTAssertNotNil(sut.titleColor(for: .highlighted))
    }

    func test_dnsApply_shouldSetDisabledStateProperties() {
        sut.dnsApply(mockButtonStyle)

        XCTAssertNotNil(sut.titleColor(for: .disabled))
    }

    func test_dnsApply_shouldSetSelectedStateProperties() {
        sut.dnsApply(mockButtonStyle)

        XCTAssertNotNil(sut.titleColor(for: .selected))
    }

    // MARK: - Edge Cases

    func test_dnsApply_withNilStyle_shouldNotCrash() {
        XCTAssertNoThrow(sut.dnsApply(DNSThemeButtonStyle.Base.default))
    }

    func test_dnsApply_afterButtonConfiguration_shouldMaintainLayout() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let originalFrame = sut.frame

        sut.dnsApply(mockButtonStyle)

        // Frame should not change unless explicitly modified by style
        XCTAssertEqual(sut.frame.size, originalFrame.size)
    }

    // MARK: - Performance Tests

    func test_dnsApply_performance() {
        measure {
            for _ in 0..<100 {
                sut.dnsApply(mockButtonStyle)
            }
        }
    }

    // MARK: - Helper Methods

    @objc private func dummyAction() {
        // Dummy action for testing target-action preservation
    }

    private func createTestImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}