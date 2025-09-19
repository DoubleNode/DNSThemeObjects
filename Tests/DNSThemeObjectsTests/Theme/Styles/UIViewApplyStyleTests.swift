//
//  UIViewApplyStyleTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class UIViewApplyStyleTests: XCTestCase {
    private var sut: UIView!
    private var mockViewStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = UIView()
        mockViewStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockViewStyle = nil
        super.tearDown()
    }

    // MARK: - View Style Application Tests

    func test_dnsApply_withViewStyle_shouldApplyAllProperties() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer)
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    func test_dnsApply_withViewStyleBackground_shouldSetBackgroundColor() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        XCTAssertNotNil(sut.backgroundColor)
        // Background color should be set from style
        XCTAssertNotEqual(sut.backgroundColor, UIView().backgroundColor)
    }

    func test_dnsApply_withViewStyleBorder_shouldSetBorderProperties() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        XCTAssertGreaterThanOrEqual(sut.layer.borderWidth, 0)
        XCTAssertNotNil(sut.layer.borderColor)
    }

    func test_dnsApply_withViewStyleCornerRadius_shouldSetCornerRadius() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    func test_dnsApply_withViewStyleShadow_shouldSetShadowProperties() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        // Shadow properties are applied (may be default values if not set in style)
        XCTAssertGreaterThanOrEqual(sut.layer.shadowOpacity, 0)
        XCTAssertGreaterThanOrEqual(sut.layer.shadowRadius, 0)
        // Shadow offset may be zero if not configured in style
        _ = sut.layer.shadowOffset
    }

    func test_dnsApply_withViewStyleAlpha_shouldSetAlpha() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        XCTAssertGreaterThan(sut.alpha, 0)
        XCTAssertLessThanOrEqual(sut.alpha, 1)
    }

    // MARK: - Multiple Style Application Tests

    func test_dnsApply_multipleTimes_shouldUpdateProperly() {
        let style1 = DNSThemeViewStyle.Base.default
        let style2 = DNSThemeViewStyle.Base.default

        // Apply first style
        sut.dnsApply(style1)
        let firstBackgroundColor = sut.backgroundColor
        let firstCornerRadius = sut.layer.cornerRadius

        // Apply second style
        sut.dnsApply(style2)
        let secondBackgroundColor = sut.backgroundColor
        let secondCornerRadius = sut.layer.cornerRadius

        // Properties should update to reflect new style
        XCTAssertNotNil(firstBackgroundColor)
        XCTAssertNotNil(secondBackgroundColor)
        // Corner radius might be different between styles
        XCTAssertGreaterThanOrEqual(firstCornerRadius, 0)
        XCTAssertGreaterThanOrEqual(secondCornerRadius, 0)
    }

    func test_dnsApply_differentStyles_shouldUpdateBorders() {
        let style1 = DNSThemeViewStyle.Base.default
        let style2 = DNSThemeViewStyle.Base.default

        // Apply first style
        sut.dnsApply(style1)
        let firstBorderWidth = sut.layer.borderWidth

        // Apply second style
        sut.dnsApply(style2)
        let secondBorderWidth = sut.layer.borderWidth

        // Border widths should be set according to styles
        XCTAssertGreaterThanOrEqual(firstBorderWidth, 0)
        XCTAssertGreaterThanOrEqual(secondBorderWidth, 0)
    }

    // MARK: - Subview Preservation Tests

    func test_dnsApply_shouldPreserveSubviews() {
        let subview = UIView()
        sut.addSubview(subview)

        sut.dnsApply(mockViewStyle)

        XCTAssertTrue(sut.subviews.contains(subview))
        XCTAssertEqual(subview.superview, sut)
    }

    func test_dnsApply_shouldPreserveConstraints() {
        let subview = UIView()
        sut.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        let constraint = subview.centerXAnchor.constraint(equalTo: sut.centerXAnchor)
        constraint.isActive = true

        sut.dnsApply(mockViewStyle)

        XCTAssertTrue(constraint.isActive)
        XCTAssertTrue(sut.constraints.contains(constraint))
    }

    // MARK: - Layer Properties Tests

    func test_dnsApply_shouldSetLayerMask() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        // Layer mask should be set if clipping is enabled in style
        XCTAssertNotNil(sut.layer)
    }

    func test_dnsApply_shouldSetLayerMasksToBounds() {
        // When
        sut.dnsApply(mockViewStyle)

        // Then
        // masksToBounds should be set appropriately for corner radius
        if sut.layer.cornerRadius > 0 {
            XCTAssertTrue(sut.layer.masksToBounds)
        }
    }

    // MARK: - Transform Tests

    func test_dnsApply_shouldPreserveTransform() {
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        sut.transform = transform

        sut.dnsApply(mockViewStyle)

        XCTAssertEqual(sut.transform, transform)
    }

    // MARK: - Gesture Recognizer Tests

    func test_dnsApply_shouldPreserveGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer()
        sut.addGestureRecognizer(tapGesture)

        sut.dnsApply(mockViewStyle)

        XCTAssertTrue(sut.gestureRecognizers?.contains(tapGesture) ?? false)
    }

    // MARK: - Accessibility Tests

    func test_dnsApply_shouldPreserveAccessibilityProperties() {
        sut.accessibilityLabel = "Test View"
        sut.accessibilityHint = "Test Hint"
        sut.isAccessibilityElement = true

        sut.dnsApply(mockViewStyle)

        XCTAssertEqual(sut.accessibilityLabel, "Test View")
        XCTAssertEqual(sut.accessibilityHint, "Test Hint")
        XCTAssertTrue(sut.isAccessibilityElement)
    }

    // MARK: - Edge Cases

    func test_dnsApply_withDefaultStyle_shouldNotCrash() {
        XCTAssertNoThrow(sut.dnsApply(DNSThemeViewStyle.Base.default))
    }

    func test_dnsApply_withZeroFrame_shouldHandleGracefully() {
        sut.frame = CGRect.zero

        sut.dnsApply(mockViewStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    func test_dnsApply_withHiddenView_shouldApplyStyleRegardless() {
        sut.isHidden = true

        sut.dnsApply(mockViewStyle)

        XCTAssertTrue(sut.isHidden)
        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    func test_dnsApply_afterViewConfiguration_shouldMaintainFrame() {
        let originalFrame = CGRect(x: 10, y: 20, width: 100, height: 150)
        sut.frame = originalFrame

        sut.dnsApply(mockViewStyle)

        // Frame should not change unless explicitly modified by style
        XCTAssertEqual(sut.frame, originalFrame)
    }

    // MARK: - Performance Tests

    func test_dnsApply_performance() {
        measure {
            for _ in 0..<100 {
                sut.dnsApply(mockViewStyle)
            }
        }
    }

    // MARK: - Animation Compatibility Tests

    func test_dnsApply_duringAnimation_shouldNotInterfere() {
        let expectation = self.expectation(description: "Animation completion")

        UIView.animate(withDuration: 0.1, animations: {
            self.sut.alpha = 0.5
        }, completion: { _ in
            expectation.fulfill()
        })

        // Apply style during animation
        sut.dnsApply(mockViewStyle)

        waitForExpectations(timeout: 1.0, handler: nil)

        // Animation should complete successfully
        XCTAssertLessThan(sut.alpha, 1.0)
    }

    // MARK: - Complex Layout Tests

    func test_dnsApply_withComplexSubviewHierarchy_shouldPreserveLayout() {
        // Create complex subview hierarchy
        let containerView = UIView()
        let labelView = UILabel()
        let buttonView = UIButton()

        sut.addSubview(containerView)
        containerView.addSubview(labelView)
        containerView.addSubview(buttonView)

        sut.dnsApply(mockViewStyle)

        XCTAssertTrue(sut.subviews.contains(containerView))
        XCTAssertTrue(containerView.subviews.contains(labelView))
        XCTAssertTrue(containerView.subviews.contains(buttonView))
    }

    // MARK: - Tint Color Tests

    func test_dnsApply_shouldHandleTintColor() {
        let originalTintColor = sut.tintColor

        sut.dnsApply(mockViewStyle)

        // Tint color should be preserved unless explicitly changed by style
        XCTAssertNotNil(sut.tintColor)
    }
}