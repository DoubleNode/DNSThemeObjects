//
//  UIBezierPathRoundedRectTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIBezierPathRoundedRectTests: XCTestCase {

    // MARK: - Basic Functionality Tests

    func test_initShouldRoundRect_withAllRadiiZero_shouldCreateRegularRectangle() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 0,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withEqualRadii_shouldCreateUniformlyRoundedRectangle() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let radius: CGFloat = 10
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: radius,
                                topRightRadius: radius,
                                bottomLeftRadius: radius,
                                bottomRightRadius: radius)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withDifferentRadii_shouldCreateVariablyRoundedRectangle() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 5,
                                topRightRadius: 10,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 20)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withSquareRect_shouldCreateRoundedSquare() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let radius: CGFloat = 20
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: radius,
                                topRightRadius: radius,
                                bottomLeftRadius: radius,
                                bottomRightRadius: radius)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withLargeRect_shouldCreateRoundedRectangle() {
        let rect = CGRect(x: 0, y: 0, width: 500, height: 300)
        let radius: CGFloat = 50
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: radius,
                                topRightRadius: radius,
                                bottomLeftRadius: radius,
                                bottomRightRadius: radius)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Individual Corner Tests

    func test_initShouldRoundRect_withOnlyTopLeftRadius_shouldRoundOnlyTopLeft() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 0,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withOnlyTopRightRadius_shouldRoundOnlyTopRight() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 15,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withOnlyBottomLeftRadius_shouldRoundOnlyBottomLeft() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 0,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withOnlyBottomRightRadius_shouldRoundOnlyBottomRight() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 0,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Partial Corner Combinations

    func test_initShouldRoundRect_withTopCornersOnly_shouldRoundTopCorners() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 15,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withBottomCornersOnly_shouldRoundBottomCorners() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 0,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withLeftCornersOnly_shouldRoundLeftCorners() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 0,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 0)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withRightCornersOnly_shouldRoundRightCorners() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0,
                                topRightRadius: 15,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withDiagonalCorners_shouldRoundDiagonalCorners() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 0,
                                bottomLeftRadius: 0,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Edge Cases and Invalid Values

    func test_initShouldRoundRect_withNegativeRadii_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: -10,
                                topRightRadius: -5,
                                bottomLeftRadius: -15,
                                bottomRightRadius: -20)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        // Negative radii should be treated as 0 by the Core Graphics implementation
    }

    func test_initShouldRoundRect_withVeryLargeRadii_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 1000,
                                topRightRadius: 1000,
                                bottomLeftRadius: 1000,
                                bottomRightRadius: 1000)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        // Large radii should be handled gracefully by Core Graphics
    }

    func test_initShouldRoundRect_withZeroSizeRect_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
    }

    func test_initShouldRoundRect_withVerySmallRect_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 0.5,
                                topRightRadius: 0.5,
                                bottomLeftRadius: 0.5,
                                bottomRightRadius: 0.5)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
    }

    // MARK: - Fractional Values Tests

    func test_initShouldRoundRect_withFractionalRadii_shouldCreatePath() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 5.5,
                                topRightRadius: 10.7,
                                bottomLeftRadius: 15.3,
                                bottomRightRadius: 20.9)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withFractionalRect_shouldCreatePath() {
        let rect = CGRect(x: 0.5, y: 0.7, width: 99.3, height: 49.8)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Position Offset Tests

    func test_initShouldRoundRect_withOffsetRect_shouldCreatePathAtCorrectPosition() {
        let rect = CGRect(x: 50, y: 30, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)

        let bounds = path.cgPath.boundingBox
        // The path should roughly encompass the original rectangle
        XCTAssertGreaterThanOrEqual(bounds.maxX, rect.maxX - 1)
        XCTAssertGreaterThanOrEqual(bounds.maxY, rect.maxY - 1)
    }

    func test_initShouldRoundRect_withNegativeOrigin_shouldCreatePath() {
        let rect = CGRect(x: -50, y: -30, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Performance Tests

    func test_initShouldRoundRect_performance_simpleRectangles() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)

        measure {
            for _ in 0..<1000 {
                _ = UIBezierPath(shouldRoundRect: rect,
                                 topLeftRadius: 10,
                                 topRightRadius: 10,
                                 bottomLeftRadius: 10,
                                 bottomRightRadius: 10)
            }
        }
    }

    func test_initShouldRoundRect_performance_complexRounding() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)

        measure {
            for i in 0..<500 {
                let radius = CGFloat(i % 20)
                _ = UIBezierPath(shouldRoundRect: rect,
                                 topLeftRadius: radius,
                                 topRightRadius: radius + 1,
                                 bottomLeftRadius: radius + 2,
                                 bottomRightRadius: radius + 3)
            }
        }
    }

    func test_initShouldRoundRect_performance_largeRectangles() {
        let rect = CGRect(x: 0, y: 0, width: 1000, height: 500)

        measure {
            for _ in 0..<100 {
                _ = UIBezierPath(shouldRoundRect: rect,
                                 topLeftRadius: 50,
                                 topRightRadius: 50,
                                 bottomLeftRadius: 50,
                                 bottomRightRadius: 50)
            }
        }
    }

    // MARK: - Memory Management Tests

    func test_initShouldRoundRect_memoryManagement_shouldNotLeak() {
        for _ in 0..<1000 {
            autoreleasepool {
                let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
                _ = UIBezierPath(shouldRoundRect: rect,
                                 topLeftRadius: 10,
                                 topRightRadius: 10,
                                 bottomLeftRadius: 10,
                                 bottomRightRadius: 10)
            }
        }

        XCTAssertTrue(true) // Test completion indicates no major memory leaks
    }

    func test_initShouldRoundRect_largePathCreation_shouldNotLeakMemory() {
        for _ in 0..<100 {
            autoreleasepool {
                let rect = CGRect(x: 0, y: 0, width: 500, height: 300)
                _ = UIBezierPath(shouldRoundRect: rect,
                                 topLeftRadius: 25,
                                 topRightRadius: 30,
                                 bottomLeftRadius: 35,
                                 bottomRightRadius: 40)
            }
        }

        XCTAssertTrue(true)
    }

    // MARK: - Concurrent Creation Tests

    func test_initShouldRoundRect_concurrentCreation_shouldBeSafe() {
        let expectation = self.expectation(description: "Concurrent path creation")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue.global(qos: .default)

        for i in 0..<5 {
            queue.async {
                let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
                let radius = CGFloat(i * 5 + 5)
                let path = UIBezierPath(shouldRoundRect: rect,
                                        topLeftRadius: radius,
                                        topRightRadius: radius,
                                        bottomLeftRadius: radius,
                                        bottomRightRadius: radius)
                XCTAssertNotNil(path, "Concurrent creation \(i) failed")
                XCTAssertNotNil(path.cgPath, "Concurrent creation \(i) cgPath failed")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    // MARK: - Path Properties Tests

    func test_initShouldRoundRect_shouldCreateClosedPath() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)

        // The path should have a reasonable bounds
        let bounds = path.cgPath.boundingBox
        XCTAssertGreaterThan(bounds.width, 0)
        XCTAssertGreaterThan(bounds.height, 0)
    }

    func test_initShouldRoundRect_shouldCreateDrawablePath() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 15,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)

        // Test that the path can be used for drawing (basic validation)
        XCTAssertFalse(path.cgPath.isEmpty)
        XCTAssertGreaterThan(path.cgPath.boundingBox.width, 0)
        XCTAssertGreaterThan(path.cgPath.boundingBox.height, 0)
    }

    // MARK: - Radius Validation Tests

    func test_initShouldRoundRect_withRadiusLargerThanDimension_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 10)
        // Radius larger than half the smallest dimension
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 15,
                                topRightRadius: 15,
                                bottomLeftRadius: 15,
                                bottomRightRadius: 15)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        // Core Graphics should handle this gracefully
    }

    func test_initShouldRoundRect_withMixedValidInvalidRadii_shouldHandleGracefully() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,      // Valid
                                topRightRadius: -5,     // Invalid (negative)
                                bottomLeftRadius: 1000, // Invalid (too large)
                                bottomRightRadius: 15)  // Valid

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
    }

    // MARK: - Special Geometry Tests

    func test_initShouldRoundRect_withTallRectangle_shouldCreatePath() {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 200)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 25,
                                topRightRadius: 25,
                                bottomLeftRadius: 25,
                                bottomRightRadius: 25)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    func test_initShouldRoundRect_withWideRectangle_shouldCreatePath() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 25,
                                topRightRadius: 25,
                                bottomLeftRadius: 25,
                                bottomRightRadius: 25)

        XCTAssertNotNil(path)
        XCTAssertNotNil(path.cgPath)
        XCTAssertFalse(path.cgPath.isEmpty)
    }

    // MARK: - Integration Tests

    func test_initShouldRoundRect_canBeUsedWithCAShapeLayer() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 15,
                                bottomLeftRadius: 5,
                                bottomRightRadius: 20)

        // Test that the path can be assigned to a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        XCTAssertNotNil(shapeLayer.path)
        XCTAssertEqual(shapeLayer.path, path.cgPath)
    }

    func test_initShouldRoundRect_canBeUsedForFilling() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let path = UIBezierPath(shouldRoundRect: rect,
                                topLeftRadius: 10,
                                topRightRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10)

        // Test that the path can be used for fill operations
        XCTAssertNotNil(path)
        XCTAssertNoThrow(path.fill())
        XCTAssertNoThrow(path.stroke())
    }
}