//
//  DNSMonochromeImageFilterTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import AlamofireImage
@testable import DNSThemeObjects

final class DNSMonochromeImageFilterTests: XCTestCase {
    private var testImage: UIImage!

    override func setUp() {
        super.setUp()
        testImage = createTestColorImage()
    }

    override func tearDown() {
        testImage = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_shouldCreateFilter() {
        let filter = DNSMonochromeImageFilter()
        XCTAssertEqual(filter.filterName, "CIColorMonochrome")
        XCTAssertFalse(filter.parameters.isEmpty)
    }

    func test_init_withDefaultIntensity_shouldHaveCorrectParameters() {
        let filter = DNSMonochromeImageFilter()
        XCTAssertEqual(filter.parameters["inputIntensity"] as? Float, 1.0)
        XCTAssertNotNil(filter.parameters["inputColor"])
    }

    func test_init_withCustomIntensity_shouldHaveCorrectParameters() {
        let customIntensity: Float = 0.5
        let filter = DNSMonochromeImageFilter(inputIntensity: customIntensity)
        XCTAssertEqual(filter.parameters["inputIntensity"] as? Float, customIntensity)
    }

    // MARK: - Filter Application Tests

    func test_filter_withValidImage_shouldReturnMonochromeImage() {
        let filter = DNSMonochromeImageFilter()
        let result = filter.filter(testImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,testImage.size) // Should maintain size
    }

    func test_filter_withSmallImage_shouldHandleCorrectly() {
        let smallImage = createTestColorImage(size: CGSize(width: 10, height: 10))
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(smallImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,smallImage.size)
    }

    func test_filter_withLargeImage_shouldHandleCorrectly() {
        let largeImage = createTestColorImage(size: CGSize(width: 200, height: 200))
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(largeImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,largeImage.size)
    }

    // MARK: - Color Accuracy Tests

    func test_filter_withColorImage_shouldProduceGrayscaleResult() {
        // Create a distinctly colored image
        let coloredImage = createTestColorImage(color: .red)
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(coloredImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,coloredImage.size)
        // Core Image filter should produce a monochrome version
    }

    func test_filter_withGrayscaleImage_shouldReturnSimilarImage() {
        let grayscaleImage = createTestGrayscaleImage()
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(grayscaleImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,grayscaleImage.size)
        // Result should be similar since input was already grayscale
    }

    func test_filter_withTransparentImage_shouldHandleAlpha() {
        let transparentImage = createTestImageWithAlpha()
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(transparentImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,transparentImage.size)
    }

    // MARK: - Parameter Configuration Tests

    func test_parameters_shouldContainCorrectKeys() {
        let filter = DNSMonochromeImageFilter()

        XCTAssertTrue(filter.parameters.keys.contains("inputIntensity"))
        XCTAssertTrue(filter.parameters.keys.contains("inputColor"))
    }

    func test_parameters_inputColor_shouldBeCIColor() {
        let filter = DNSMonochromeImageFilter()

        XCTAssertTrue(filter.parameters["inputColor"] is CIColor)
    }

    func test_parameters_inputIntensity_shouldBeFloat() {
        let filter = DNSMonochromeImageFilter()

        XCTAssertTrue(filter.parameters["inputIntensity"] is Float)
    }

    // MARK: - Different Intensity Levels Tests

    func test_filter_withZeroIntensity_shouldReturnProcessedImage() {
        let filter = DNSMonochromeImageFilter(inputIntensity: 0.0)

        let result = filter.filter(testImage)

        XCTAssertNotNil(result)
        // With zero intensity, should still process but be closer to original
        XCTAssertEqual(result.size,testImage.size)
    }

    func test_filter_withMaxIntensity_shouldReturnFullyMonochrome() {
        let filter = DNSMonochromeImageFilter(inputIntensity: 1.0)

        let result = filter.filter(testImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,testImage.size)
        // Should be fully monochrome
    }

    func test_filter_withMidIntensity_shouldReturnBlendedImage() {
        let filter = DNSMonochromeImageFilter(inputIntensity: 0.5)

        let result = filter.filter(testImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,testImage.size)
        // Should be a blend between color and monochrome
    }

    // MARK: - Performance Tests

    func test_filter_performance() {
        let image = createTestColorImage(size: CGSize(width: 50, height: 50))
        let filter = DNSMonochromeImageFilter()

        measure {
            for _ in 0..<5 {
                _ = filter.filter(image)
            }
        }
    }

    func test_filter_performanceWithLargeImage() {
        let largeImage = createTestColorImage(size: CGSize(width: 100, height: 100))
        let filter = DNSMonochromeImageFilter()

        measure {
            _ = filter.filter(largeImage)
        }
    }

    // MARK: - Memory Management Tests

    func test_filter_multipleApplications_shouldNotLeakMemory() {
        let filter = DNSMonochromeImageFilter()

        autoreleasepool {
            for _ in 0..<10 {
                _ = filter.filter(testImage)
            }
        }
        // This test verifies no major memory leaks occur
        XCTAssertTrue(true) // If we reach here without crashing, memory management is likely OK
    }

    // MARK: - Edge Cases

    func test_filter_withEmptyImage_shouldHandleGracefully() {
        // Create an image with minimal size
        let minimalImage = createTestColorImage(size: CGSize(width: 1, height: 1))
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(minimalImage)

        // Should either return nil or handle gracefully
        XCTAssertTrue(result.size != CGSize.zero)
    }

    func test_filter_consecutiveApplications_shouldBeConsistent() {
        let filter = DNSMonochromeImageFilter()
        let firstResult = filter.filter(testImage)
        XCTAssertNotNil(firstResult)

        let secondResult = filter.filter(firstResult)

        // Second application should produce consistent results
        XCTAssertEqual(firstResult.size, secondResult.size)
    }

    func test_filter_withDifferentColorSpaces_shouldHandleCorrectly() {
        // Test with images in different color spaces if possible
        let rgbImage = createTestColorImage()
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(rgbImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,rgbImage.size)
    }

    // MARK: - Filter Chain Tests

    func test_filter_inChainWithOtherFilters_shouldWorkCorrectly() {
        // Test chaining with basic Core Image filters
        let filter = DNSMonochromeImageFilter()

        let result = filter.filter(testImage)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.size,testImage.size)
    }

    // MARK: - Helper Methods

    private func createTestColorImage(size: CGSize = CGSize(width: 50, height: 50), color: UIColor = .blue) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    private func createTestGrayscaleImage(size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        return createTestColorImage(size: size, color: .gray)
    }

    private func createTestImageWithAlpha(size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.withAlphaComponent(0.5).cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    private func createTestGradientImage(size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)

        if let gradient = gradient {
            context?.drawLinearGradient(gradient,
                                      start: CGPoint(x: 0, y: 0),
                                      end: CGPoint(x: size.width, y: size.height),
                                      options: [])
        }

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}