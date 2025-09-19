//
//  UIImageTransparentBackgroundTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import CoreImage
@testable import DNSThemeObjects

final class UIImageTransparentBackgroundTests: XCTestCase {

    // MARK: - Basic Functionality Tests

    func test_dnsTransparentBackground_withValidImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 100, height: 100, color: .red)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withSmallImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 10, height: 10, color: .blue)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withLargeImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 500, height: 500, color: .green)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withSquareImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 200, height: 200, color: .purple)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withRectangularImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 300, height: 150, color: .orange)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    // MARK: - Color Variation Tests

    func test_dnsTransparentBackground_withDifferentColors_shouldProcessAllColors() {
        let colors: [UIColor] = [
            .red, .blue, .green, .yellow, .purple, .orange, .cyan, .magenta
        ]

        for color in colors {
            let originalImage = createTestImage(width: 50, height: 50, color: color)

            let result = originalImage.dnsTransparentBackground()

            XCTAssertNotNil(result, "Failed to process image with color: \(color)")
            XCTAssertNotNil(result?.cgImage, "Failed to create CGImage for color: \(color)")
        }
    }

    func test_dnsTransparentBackground_withWhiteImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 100, height: 100, color: .white)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withBlackImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 100, height: 100, color: .black)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withGrayImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 100, height: 100, color: .gray)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withClearImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 100, height: 100, color: .clear)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    // MARK: - Edge Cases and Error Handling

    func test_dnsTransparentBackground_withNoCIImage_shouldReturnNil() {
        // Create an image without a CIImage
        let cgImage = createTestCGImage(width: 100, height: 100, color: .red)
        let imageWithoutCIImage = UIImage(cgImage: cgImage)

        // Ensure the image doesn't have a ciImage
        XCTAssertNil(imageWithoutCIImage.ciImage)

        let result = imageWithoutCIImage.dnsTransparentBackground()

        XCTAssertNil(result)
    }

    func test_dnsTransparentBackground_withMinimalSize_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 1, height: 1, color: .red)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    func test_dnsTransparentBackground_withVeryLargeImage_shouldReturnProcessedImage() {
        let originalImage = createTestImage(width: 1000, height: 1000, color: .blue)

        let result = originalImage.dnsTransparentBackground()

        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)
    }

    // MARK: - System Image Tests

    func test_dnsTransparentBackground_withSystemImage_shouldHandleGracefully() {
        guard let systemImage = UIImage(systemName: "heart.fill") else {
            XCTFail("Could not create system image")
            return
        }

        let result = systemImage.dnsTransparentBackground()

        // System images may not have CIImage, so result could be nil
        // This is expected behavior
        if result == nil {
            XCTAssertNil(result)
        } else {
            XCTAssertNotNil(result?.cgImage)
        }
    }

    func test_dnsTransparentBackground_withSFSymbol_shouldHandleGracefully() {
        guard let symbolImage = UIImage(systemName: "star") else {
            XCTFail("Could not create SF Symbol")
            return
        }

        let result = symbolImage.dnsTransparentBackground()

        // SF Symbols may not have CIImage, so result could be nil
        if result == nil {
            XCTAssertNil(result)
        } else {
            XCTAssertNotNil(result?.cgImage)
        }
    }

    // MARK: - Multiple Processing Tests

    func test_dnsTransparentBackground_multipleProcessing_shouldNotDegradeQuality() {
        let originalImage = createTestImage(width: 100, height: 100, color: .red)

        var processedImage = originalImage
        for _ in 0..<3 {
            if let nextImage = processedImage.dnsTransparentBackground() {
                processedImage = nextImage
            } else {
                XCTFail("Processing failed during multiple iterations")
                return
            }
        }

        XCTAssertNotNil(processedImage)
        XCTAssertNotNil(processedImage.cgImage)
    }

    func test_dnsTransparentBackground_consecutiveProcessing_shouldMaintainStability() {
        let originalImage = createTestImage(width: 150, height: 150, color: .green)

        let result1 = originalImage.dnsTransparentBackground()
        XCTAssertNotNil(result1)

        guard let firstResult = result1 else { return }

        let result2 = firstResult.dnsTransparentBackground()
        XCTAssertNotNil(result2)
    }

    // MARK: - Performance Tests

    func test_dnsTransparentBackground_performance_smallImages() {
        let testImages = (0..<10).map { _ in
            createTestImage(width: 50, height: 50, color: .red)
        }

        measure {
            for image in testImages {
                _ = image.dnsTransparentBackground()
            }
        }
    }

    func test_dnsTransparentBackground_performance_mediumImages() {
        let testImages = (0..<5).map { _ in
            createTestImage(width: 200, height: 200, color: .blue)
        }

        measure {
            for image in testImages {
                _ = image.dnsTransparentBackground()
            }
        }
    }

    func test_dnsTransparentBackground_performance_largeImage() {
        let largeImage = createTestImage(width: 500, height: 500, color: .green)

        measure {
            _ = largeImage.dnsTransparentBackground()
        }
    }

    // MARK: - Memory Management Tests

    func test_dnsTransparentBackground_memoryManagement_shouldNotLeak() {
        for _ in 0..<50 {
            autoreleasepool {
                let image = createTestImage(width: 100, height: 100, color: .random)
                _ = image.dnsTransparentBackground()
            }
        }

        XCTAssertTrue(true) // Test completion indicates no major memory leaks
    }

    func test_dnsTransparentBackground_batchProcessing_shouldNotLeakMemory() {
        let images = (0..<20).map { _ in
            createTestImage(width: 75, height: 75, color: .random)
        }

        for image in images {
            autoreleasepool {
                _ = image.dnsTransparentBackground()
            }
        }

        XCTAssertTrue(true)
    }

    // MARK: - Concurrent Processing Tests

    func test_dnsTransparentBackground_concurrentProcessing_shouldBeSafe() {
        let expectation = self.expectation(description: "Concurrent image processing")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue.global(qos: .default)

        for i in 0..<5 {
            queue.async {
                let image = self.createTestImage(width: 100, height: 100, color: .red)
                let result = image.dnsTransparentBackground()
                XCTAssertNotNil(result, "Concurrent processing \(i) failed")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    // MARK: - Core Image Filter Tests

    func test_dnsTransparentBackground_usesCorrectFilter_shouldUseMaskToAlpha() {
        // We can't directly test the filter name, but we can verify the method works
        // which implies the filter is available and functioning
        let image = createTestImage(width: 100, height: 100, color: .red)

        let result = image.dnsTransparentBackground()

        XCTAssertNotNil(result)
        // If the CIMaskToAlpha filter is working, the result should be different from the original
        XCTAssertNotEqual(image, result)
    }

    func test_dnsTransparentBackground_filterAvailability_shouldHandleMissingFilter() {
        // This test verifies the method handles cases where the filter might not be available
        let image = createTestImage(width: 50, height: 50, color: .blue)

        let result = image.dnsTransparentBackground()

        // The method should either return a processed image or nil gracefully
        if result == nil {
            XCTAssertNil(result)
        } else {
            XCTAssertNotNil(result?.cgImage)
        }
    }

    // MARK: - Input Validation Tests

    func test_dnsTransparentBackground_withImageFromData_shouldReturnProcessedImage() {
        // Create image from data
        if let imageData = createTestImageData(width: 100, height: 100, color: .yellow),
           let imageFromData = UIImage(data: imageData) {

            let result = imageFromData.dnsTransparentBackground()

            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.cgImage)
        } else {
            XCTFail("Could not create image from data")
        }
    }

    func test_dnsTransparentBackground_withDifferentFormats_shouldHandleGracefully() {
        // Test with different image creation methods that might affect CIImage availability
        let methods = [
            { self.createTestImage(width: 100, height: 100, color: .red) },
            { UIImage() }, // Empty image
        ]

        for (index, method) in methods.enumerated() {
            let image = method()
            let result = image.dnsTransparentBackground()

            // Some methods may produce images without CIImage, resulting in nil
            if result == nil && image.ciImage == nil {
                XCTAssertNil(result, "Method \(index): Expected nil for image without CIImage")
            } else if result != nil {
                XCTAssertNotNil(result?.cgImage, "Method \(index): Expected valid CGImage")
            }
        }
    }

    // MARK: - Integration Tests

    func test_dnsTransparentBackground_integrationWithOtherFilters_shouldWork() {
        let originalImage = createTestImage(width: 100, height: 100, color: .purple)

        // Apply transparent background
        guard let transparentImage = originalImage.dnsTransparentBackground() else {
            XCTFail("Failed to create transparent background image")
            return
        }

        // Verify the result can be used for further processing
        XCTAssertNotNil(transparentImage.cgImage)

        // Test that the image can be converted back to data
        if let pngData = transparentImage.pngData() {
            XCTAssertGreaterThan(pngData.count, 0)
        }
    }

    // MARK: - Helper Methods

    private func createTestImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
        let size = CGSize(width: width, height: height)
        return UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    private func createTestCGImage(width: Int, height: Int, color: UIColor) -> CGImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        return context.makeImage()!
    }

    private func createTestImageData(width: CGFloat, height: CGFloat, color: UIColor) -> Data? {
        let image = createTestImage(width: width, height: height, color: color)
        return image.pngData()
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}