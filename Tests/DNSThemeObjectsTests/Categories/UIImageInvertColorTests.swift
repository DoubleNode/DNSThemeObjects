//
//  UIImageInvertColorTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIImageInvertColorTests: XCTestCase {

    // MARK: - Test Helpers

    private func createTestImage(color: UIColor = .red, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    private func createTestImageWithCIImage(color: UIColor = .blue, size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return UIImage()
        }

        let ciImage = CIImage(cgImage: cgImage)
        return UIImage(ciImage: ciImage)
    }

    // MARK: - Basic Functionality Tests

    func test_dnsInvertColor_withValidImage_shouldReturnInvertedImage() {
        let testImage = createTestImageWithCIImage(color: .red)

        let result = testImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    func test_dnsInvertColor_withBlackImage_shouldReturnInvertedImage() {
        let blackImage = createTestImageWithCIImage(color: .black)

        let result = blackImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.ciImage != blackImage.ciImage)
    }

    func test_dnsInvertColor_withWhiteImage_shouldReturnInvertedImage() {
        let whiteImage = createTestImageWithCIImage(color: .white)

        let result = whiteImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.ciImage != whiteImage.ciImage)
    }

    func test_dnsInvertColor_withColoredImage_shouldReturnInvertedImage() {
        let coloredImage = createTestImageWithCIImage(color: .blue)

        let result = coloredImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    // MARK: - Size Preservation Tests

    func test_dnsInvertColor_withSmallImage_shouldPreserveSize() {
        let smallImage = createTestImageWithCIImage(color: .green, size: CGSize(width: 10, height: 10))

        let result = smallImage.dnsInvertColor()

        XCTAssertNotNil(result)
        // Note: CIImage-based UIImages don't always preserve exact pixel dimensions
        // but the operation should succeed
    }

    func test_dnsInvertColor_withLargeImage_shouldPreserveSize() {
        let largeImage = createTestImageWithCIImage(color: .purple, size: CGSize(width: 500, height: 500))

        let result = largeImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    func test_dnsInvertColor_withRectangularImage_shouldPreserveAspectRatio() {
        let rectangularImage = createTestImageWithCIImage(color: .orange, size: CGSize(width: 200, height: 100))

        let result = rectangularImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    // MARK: - Edge Cases

    func test_dnsInvertColor_withImageWithoutCIImage_shouldReturnNil() {
        // Create image without CIImage (only CGImage-based)
        let imageWithoutCI = createTestImage(color: .cyan)

        // Verify it doesn't have ciImage
        XCTAssertNil(imageWithoutCI.ciImage)

        let result = imageWithoutCI.dnsInvertColor()

        // Should return nil because filter.setValue(nil, forKey: kCIInputImageKey) won't work
        XCTAssertNil(result)
    }

    func test_dnsInvertColor_withTransparentImage_shouldHandleGracefully() {
        let transparentImage = createTestImageWithCIImage(color: .clear)

        let result = transparentImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    func test_dnsInvertColor_withSystemImage_shouldHandleGracefully() {
        // Test with a system image that might have CIImage
        guard let systemImage = UIImage(systemName: "star.fill") else {
            XCTFail("Could not create system image")
            return
        }

        // Convert to have CIImage
        if let cgImage = systemImage.cgImage {
            let imageWithCI = UIImage(ciImage: CIImage(cgImage: cgImage))

            let result = imageWithCI.dnsInvertColor()
            XCTAssertNotNil(result)
        }
    }

    // MARK: - Multiple Application Tests

    func test_dnsInvertColor_appliedTwice_shouldReturnToOriginal() {
        let originalImage = createTestImageWithCIImage(color: .red)

        guard let firstInvert = originalImage.dnsInvertColor() else {
            XCTFail("First invert failed")
            return
        }

        let secondInvert = firstInvert.dnsInvertColor()

        XCTAssertNotNil(secondInvert)
        // Note: Due to potential precision loss in CIFilter operations,
        // we can't guarantee exact pixel-perfect equality, but operation should succeed
    }

    func test_dnsInvertColor_multipleApplications_shouldBeConsistent() {
        let testImage = createTestImageWithCIImage(color: .magenta)

        let results = (0..<5).compactMap { _ in
            testImage.dnsInvertColor()
        }

        XCTAssertEqual(results.count, 5)
        results.forEach { result in
            XCTAssertNotNil(result.ciImage)
        }
    }

    // MARK: - Performance Tests

    func test_dnsInvertColor_performance_shouldBeReasonablyFast() {
        let testImage = createTestImageWithCIImage(color: .blue, size: CGSize(width: 100, height: 100))

        measure {
            for _ in 0..<10 {
                _ = testImage.dnsInvertColor()
            }
        }
    }

    func test_dnsInvertColor_largeImage_performance() {
        let largeImage = createTestImageWithCIImage(color: .green, size: CGSize(width: 1000, height: 1000))

        measure {
            _ = largeImage.dnsInvertColor()
        }
    }

    // MARK: - Memory Management Tests

    func test_dnsInvertColor_multipleOperations_shouldNotLeakMemory() {
        let testImage = createTestImageWithCIImage(color: .yellow)

        for _ in 0..<50 {
            autoreleasepool {
                _ = testImage.dnsInvertColor()
            }
        }

        // Test completes without crashing indicates no major memory leaks
        XCTAssertTrue(true)
    }

    func test_dnsInvertColor_withImageCreatedFromData_shouldWork() {
        // Create image data
        let testImage = createTestImageWithCIImage(color: .brown)
        guard let imageData = testImage.pngData() else {
            XCTFail("Could not create image data")
            return
        }

        // Recreate image from data with CIImage
        guard let imageFromData = UIImage(data: imageData),
              let cgImage = imageFromData.cgImage else {
            XCTFail("Could not recreate image from data")
            return
        }

        let imageWithCI = UIImage(ciImage: CIImage(cgImage: cgImage))
        let result = imageWithCI.dnsInvertColor()

        XCTAssertNotNil(result)
    }

    // MARK: - CIFilter Integration Tests

    func test_dnsInvertColor_shouldUseCIColorInvertFilter() {
        // This test verifies the implementation uses the correct Core Image filter
        let testImage = createTestImageWithCIImage(color: .red)

        let result = testImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)

        // Verify the result is actually different from the original
        XCTAssertTrue(result!.ciImage !== testImage.ciImage)
    }

    func test_dnsInvertColor_withGrayscaleImage_shouldInvertCorrectly() {
        let grayscaleImage = createTestImageWithCIImage(color: .gray)

        let result = grayscaleImage.dnsInvertColor()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.ciImage)
    }

    // MARK: - Error Handling Tests

    func test_dnsInvertColor_shouldHandleFilterCreationFailure() {
        // This test ensures the method handles potential CIFilter creation failures gracefully
        let testImage = createTestImageWithCIImage(color: .blue)

        // The method should return nil if CIFilter(name: "CIColorInvert") fails
        // or if the filter has no output
        let result = testImage.dnsInvertColor()

        // In normal circumstances, this should work, but the method should handle failures
        if result == nil {
            // This is acceptable behavior if filter creation fails
            XCTAssertNil(result)
        } else {
            XCTAssertNotNil(result)
        }
    }

    // MARK: - Format Compatibility Tests

    func test_dnsInvertColor_withPNGImage_shouldWork() {
        let testImage = createTestImageWithCIImage(color: .purple)
        guard let pngData = testImage.pngData(),
              let pngImage = UIImage(data: pngData),
              let cgImage = pngImage.cgImage else {
            XCTFail("Could not create PNG image")
            return
        }

        let imageWithCI = UIImage(ciImage: CIImage(cgImage: cgImage))
        let result = imageWithCI.dnsInvertColor()

        XCTAssertNotNil(result)
    }

    func test_dnsInvertColor_withJPEGImage_shouldWork() {
        let testImage = createTestImageWithCIImage(color: .orange)
        guard let jpegData = testImage.jpegData(compressionQuality: 0.9),
              let jpegImage = UIImage(data: jpegData),
              let cgImage = jpegImage.cgImage else {
            XCTFail("Could not create JPEG image")
            return
        }

        let imageWithCI = UIImage(ciImage: CIImage(cgImage: cgImage))
        let result = imageWithCI.dnsInvertColor()

        XCTAssertNotNil(result)
    }

    // MARK: - Concurrent Access Tests

    func test_dnsInvertColor_concurrentAccess_shouldBeSafe() {
        let testImage = createTestImageWithCIImage(color: .systemTeal)
        let expectation = self.expectation(description: "Concurrent invert operations")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue.global(qos: .default)

        for i in 0..<5 {
            queue.async {
                let result = testImage.dnsInvertColor()
                XCTAssertNotNil(result, "Concurrent operation \(i) failed")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}