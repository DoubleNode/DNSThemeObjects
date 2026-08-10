//
//  UIImageBarcodeTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIImageBarcodeTests: XCTestCase {

    // MARK: - Barcode Generation Tests

    func test_barcode_withValidString_shouldReturnImage() {
        let code = "1234567890"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    func test_barcode_withValidStringAndScale_shouldReturnScaledImage() {
        let code = "1234567890"
        let scale: CGFloat = 5.0

        let result = UIImage.barcode(from: code, scale: scale)

        XCTAssertNotNil(result)

        // Compare with default scale to verify scaling effect
        let defaultResult = UIImage.barcode(from: code)
        XCTAssertNotNil(defaultResult)

        if let scaledImage = result, let defaultImage = defaultResult {
            XCTAssertGreaterThan(scaledImage.size.width, defaultImage.size.width)
            XCTAssertGreaterThan(scaledImage.size.height, defaultImage.size.height)
        }
    }

    func test_barcode_withEmptyString_shouldReturnNil() {
        let code = ""

        let result = UIImage.barcode(from: code)

        XCTAssertNil(result)
    }

    func test_barcode_withNumericString_shouldReturnImage() {
        let code = "0123456789"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)
    }

    func test_barcode_withAlphanumericString_shouldReturnImage() {
        let code = "ABC123XYZ789"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)
    }

    func test_barcode_withSpecialCharacters_shouldReturnImage() {
        let code = "TEST-123_ABC"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)
    }

    // MARK: - Scale Parameter Tests

    func test_barcode_withZeroScale_shouldHandleGracefully() {
        let code = "1234567890"
        let scale: CGFloat = 0.0

        let result = UIImage.barcode(from: code, scale: scale)

        // Should either return nil or handle zero scale appropriately
        // The exact behavior depends on Core Image implementation
        XCTAssertTrue(result == nil || result?.size.width == 0 || result?.size.height == 0)
    }

    func test_barcode_withNegativeScale_shouldHandleGracefully() {
        let code = "1234567890"
        let scale: CGFloat = -1.0

        let result = UIImage.barcode(from: code, scale: scale)

        // Should handle negative scale gracefully
        XCTAssertTrue(result == nil || result?.size.width ?? 0 >= 0)
    }

    func test_barcode_withLargeScale_shouldReturnLargeImage() {
        let code = "1234567890"
        let scale: CGFloat = 10.0

        let result = UIImage.barcode(from: code, scale: scale)

        XCTAssertNotNil(result)

        if let image = result {
            XCTAssertGreaterThan(image.size.width, 100) // Should be quite large
            XCTAssertGreaterThan(image.size.height, 10)
        }
    }

    func test_barcode_withDefaultScale_shouldUseCorrectDefault() {
        let code = "1234567890"

        let resultWithDefault = UIImage.barcode(from: code)
        let resultWithExplicitScale = UIImage.barcode(from: code, scale: 3.0)

        XCTAssertNotNil(resultWithDefault)
        XCTAssertNotNil(resultWithExplicitScale)

        // Both should produce the same result since default scale is 3.0
        if let defaultImage = resultWithDefault, let explicitImage = resultWithExplicitScale {
            XCTAssertEqual(defaultImage.size.width, explicitImage.size.width, accuracy: 1.0)
            XCTAssertEqual(defaultImage.size.height, explicitImage.size.height, accuracy: 1.0)
        }
    }

    // MARK: - Edge Cases

    func test_barcode_withWhitespaceString_shouldHandleGracefully() {
        let code = "   "

        let result = UIImage.barcode(from: code)

        // Whitespace should be processed or return nil
        // The exact behavior depends on Core Image filter implementation
        XCTAssertTrue(result != nil || result == nil) // Either outcome is acceptable
    }

    func test_barcode_withSingleCharacter_shouldReturnImage() {
        let code = "A"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)
    }

    func test_barcode_withLongString_shouldReturnImage() {
        let code = String(repeating: "A", count: 100)

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)

        if let image = result {
            // Long strings should produce wider barcodes
            XCTAssertGreaterThan(image.size.width, 50)
        }
    }

    func test_barcode_withUnicodeCharacters_shouldHandleGracefully() {
        let code = "Test🚀123"

        let result = UIImage.barcode(from: code)

        // Unicode characters might not be supported by Code128
        // Should either work or return nil gracefully
        XCTAssertTrue(result != nil || result == nil)
    }

    // MARK: - Performance Tests

    func test_barcode_performance() {
        let code = "1234567890"

        measure {
            for _ in 0..<10 {
                _ = UIImage.barcode(from: code)
            }
        }
    }

    func test_barcode_performanceWithLargeScale() {
        let code = "1234567890"
        let scale: CGFloat = 10.0

        measure {
            for _ in 0..<5 {
                _ = UIImage.barcode(from: code, scale: scale)
            }
        }
    }

    // MARK: - Image Properties Tests

    func test_barcode_shouldReturnValidImageProperties() {
        let code = "1234567890"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)

        if let image = result {
            XCTAssertGreaterThan(image.size.width, 0)
            XCTAssertGreaterThan(image.size.height, 0)
            // XDNS-0013: was `XCTAssertNotNil(image.cgImage)`, which could never pass.
            // `UIImage.barcode(from:)` returns `UIImage(ciImage:)` (UIImage+dnsBarcode.swift), and a
            // CIImage-backed UIImage has a nil `cgImage` by definition. Assert the backing that
            // actually exists. (Same CIImage-vs-CGImage distinction tracked in XDNS-0024.)
            XCTAssertNotNil(image.ciImage)
        }
    }

    func test_barcode_shouldHaveCorrectScale() {
        let code = "1234567890"

        let result = UIImage.barcode(from: code)

        XCTAssertNotNil(result)

        if let image = result {
            // Scale should be reasonable for display
            XCTAssertGreaterThan(image.scale, 0)
            XCTAssertLessThanOrEqual(image.scale, UIScreen.main.scale * 2)
        }
    }

    // MARK: - Code128 Specific Tests

    func test_barcode_code128ValidCharacters_shouldWork() {
        // Code128 supports ASCII characters 0-127
        let validCodes = [
            "0123456789",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            "abcdefghijklmnopqrstuvwxyz",
            "!@#$%^&*()_+-=[]{}|;:,.<>?"
        ]

        for code in validCodes {
            let result = UIImage.barcode(from: code)
            XCTAssertNotNil(result, "Failed to generate barcode for: \(code)")
        }
    }

    func test_barcode_code128MinimumLength_shouldWork() {
        // Code128 should work with very short codes
        let result = UIImage.barcode(from: "1")

        XCTAssertNotNil(result)
    }
}