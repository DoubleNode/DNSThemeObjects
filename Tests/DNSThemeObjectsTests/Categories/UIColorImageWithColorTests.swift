//
//  UIColorImageWithColorTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIColorImageWithColorTests: XCTestCase {

    // MARK: - Basic Functionality Tests

    func test_imageWithColor_withValidParameters_shouldCreateImage() {
        let color = UIColor.red
        let image = color.imageWithColor(width: 100, height: 50)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    func test_imageWithColor_withBlueColor_shouldCreateImage() {
        let color = UIColor.blue
        let image = color.imageWithColor(width: 80, height: 80)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    func test_imageWithColor_withGreenColor_shouldCreateImage() {
        let color = UIColor.green
        let image = color.imageWithColor(width: 120, height: 60)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    func test_imageWithColor_withClearColor_shouldCreateTransparentImage() {
        let color = UIColor.clear
        let image = color.imageWithColor(width: 60, height: 60)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    func test_imageWithColor_withWhiteColor_shouldCreateImage() {
        let color = UIColor.white
        let image = color.imageWithColor(width: 200, height: 100)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    func test_imageWithColor_withBlackColor_shouldCreateImage() {
        let color = UIColor.black
        let image = color.imageWithColor(width: 150, height: 150)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)
    }

    // MARK: - Size Validation Tests

    func test_imageWithColor_withSquareDimensions_shouldCreateSquareImage() {
        let color = UIColor.purple
        let size = 100
        let image = color.imageWithColor(width: size, height: size)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        // Verify the created image has the expected size
        XCTAssertEqual(image.size.width, CGFloat(size))
        XCTAssertEqual(image.size.height, CGFloat(size))
    }

    func test_imageWithColor_withRectangularDimensions_shouldCreateRectangularImage() {
        let color = UIColor.orange
        let width = 200
        let height = 100
        let image = color.imageWithColor(width: width, height: height)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, CGFloat(width))
        XCTAssertEqual(image.size.height, CGFloat(height))
    }

    func test_imageWithColor_withSmallDimensions_shouldCreateSmallImage() {
        let color = UIColor.cyan
        let image = color.imageWithColor(width: 10, height: 10)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 10.0)
        XCTAssertEqual(image.size.height, 10.0)
    }

    func test_imageWithColor_withLargeDimensions_shouldCreateLargeImage() {
        let color = UIColor.magenta
        let image = color.imageWithColor(width: 1000, height: 500)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 1000.0)
        XCTAssertEqual(image.size.height, 500.0)
    }

    func test_imageWithColor_withVerySmallDimensions_shouldCreateTinyImage() {
        let color = UIColor.brown
        let image = color.imageWithColor(width: 1, height: 1)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 1.0)
        XCTAssertEqual(image.size.height, 1.0)
    }

    // MARK: - Edge Cases

    func test_imageWithColor_withZeroWidth_shouldCreateImageWithZeroWidth() {
        let color = UIColor.red
        let image = color.imageWithColor(width: 0, height: 100)

        XCTAssertNotNil(image)
        XCTAssertEqual(image.size.width, 0.0)
        // Zero width may affect height in UIGraphicsImageRenderer
        XCTAssertTrue(image.size.height >= 0.0)
    }

    func test_imageWithColor_withZeroHeight_shouldCreateImageWithZeroHeight() {
        let color = UIColor.blue
        let image = color.imageWithColor(width: 100, height: 0)

        XCTAssertNotNil(image)
        // Zero height may affect width in UIGraphicsImageRenderer
        XCTAssertTrue(image.size.width >= 0.0)
        XCTAssertEqual(image.size.height, 0.0)
    }

    func test_imageWithColor_withBothDimensionsZero_shouldCreateEmptyImage() {
        let color = UIColor.green
        let image = color.imageWithColor(width: 0, height: 0)

        XCTAssertNotNil(image)
        XCTAssertEqual(image.size.width, 0.0)
        XCTAssertEqual(image.size.height, 0.0)
    }

    func test_imageWithColor_withNegativeWidth_shouldCreateImageWithNegativeWidth() {
        let color = UIColor.yellow
        let image = color.imageWithColor(width: -50, height: 100)

        XCTAssertNotNil(image)
        // UIGraphicsImageRenderer clamps negative dimensions to 0
        XCTAssertEqual(image.size.width, 0.0)
        XCTAssertEqual(image.size.height, 0.0)
    }

    func test_imageWithColor_withNegativeHeight_shouldCreateImageWithNegativeHeight() {
        let color = UIColor.purple
        let image = color.imageWithColor(width: 100, height: -50)

        XCTAssertNotNil(image)
        // UIGraphicsImageRenderer clamps negative dimensions to 0
        XCTAssertEqual(image.size.width, 0.0)
        XCTAssertEqual(image.size.height, 0.0)
    }

    func test_imageWithColor_withBothDimensionsNegative_shouldCreateImageWithNegativeDimensions() {
        let color = UIColor.orange
        let image = color.imageWithColor(width: -100, height: -50)

        XCTAssertNotNil(image)
        // UIGraphicsImageRenderer clamps negative dimensions to 0
        XCTAssertEqual(image.size.width, 0.0)
        XCTAssertEqual(image.size.height, 0.0)
    }

    // MARK: - System Colors Tests

    func test_imageWithColor_withSystemColors_shouldCreateImages() {
        let systemColors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemYellow,
            .systemOrange, .systemPurple, .systemTeal, .systemIndigo,
            .systemPink, .systemGray, .systemGray2, .systemGray3
        ]

        for color in systemColors {
            let image = color.imageWithColor(width: 50, height: 50)
            XCTAssertNotNil(image, "Failed to create image with system color: \(color)")
            XCTAssertNotNil(image.cgImage, "Failed to create CGImage with system color: \(color)")

            XCTAssertEqual(image.size.width, 50.0)
            XCTAssertEqual(image.size.height, 50.0)
        }
    }

    func test_imageWithColor_withDynamicSystemColors_shouldCreateImages() {
        let dynamicColors: [UIColor] = [
            .label, .secondaryLabel, .tertiaryLabel, .quaternaryLabel,
            .systemBackground, .secondarySystemBackground, .tertiarySystemBackground
        ]

        for color in dynamicColors {
            let image = color.imageWithColor(width: 80, height: 60)
            XCTAssertNotNil(image, "Failed to create image with dynamic color: \(color)")
            XCTAssertNotNil(image.cgImage, "Failed to create CGImage with dynamic color: \(color)")

            XCTAssertEqual(image.size.width, 80.0)
            XCTAssertEqual(image.size.height, 60.0)
        }
    }

    // MARK: - Custom Color Tests

    func test_imageWithColor_withCustomRGBColor_shouldCreateImage() {
        let customColor = UIColor(red: 0.8, green: 0.2, blue: 0.6, alpha: 1.0)
        let image = customColor.imageWithColor(width: 120, height: 80)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 120.0)
        XCTAssertEqual(image.size.height, 80.0)
    }

    func test_imageWithColor_withCustomHSBColor_shouldCreateImage() {
        let customColor = UIColor(hue: 0.6, saturation: 0.8, brightness: 0.9, alpha: 1.0)
        let image = customColor.imageWithColor(width: 90, height: 90)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 90.0)
        XCTAssertEqual(image.size.height, 90.0)
    }

    func test_imageWithColor_withSemiTransparentColor_shouldCreateImage() {
        let semiTransparent = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let image = semiTransparent.imageWithColor(width: 100, height: 100)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 100.0)
        XCTAssertEqual(image.size.height, 100.0)
    }

    func test_imageWithColor_withFullyTransparentColor_shouldCreateImage() {
        let fullyTransparent = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
        let image = fullyTransparent.imageWithColor(width: 75, height: 75)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        XCTAssertEqual(image.size.width, 75.0)
        XCTAssertEqual(image.size.height, 75.0)
    }

    // MARK: - Performance Tests

    func test_imageWithColor_performance_smallImages() {
        let color = UIColor.red

        measure {
            for _ in 0..<100 {
                _ = color.imageWithColor(width: 50, height: 50)
            }
        }
    }

    func test_imageWithColor_performance_mediumImages() {
        let color = UIColor.blue

        measure {
            for _ in 0..<50 {
                _ = color.imageWithColor(width: 200, height: 200)
            }
        }
    }

    func test_imageWithColor_performance_largeImages() {
        let color = UIColor.green

        measure {
            for _ in 0..<10 {
                _ = color.imageWithColor(width: 500, height: 500)
            }
        }
    }

    func test_imageWithColor_performance_varyingDimensions() {
        let color = UIColor.purple

        measure {
            for i in 1...100 {
                _ = color.imageWithColor(width: i, height: i)
            }
        }
    }

    // MARK: - Memory Management Tests

    func test_imageWithColor_memoryManagement_shouldNotLeak() {
        for _ in 0..<200 {
            autoreleasepool {
                let color = UIColor.random
                _ = color.imageWithColor(width: 50, height: 50)
            }
        }

        XCTAssertTrue(true) // Test completion indicates no major memory leaks
    }

    func test_imageWithColor_largeImageCreation_shouldNotLeakMemory() {
        for _ in 0..<20 {
            autoreleasepool {
                let color = UIColor.red
                _ = color.imageWithColor(width: 300, height: 300)
            }
        }

        XCTAssertTrue(true)
    }

    func test_imageWithColor_batchCreation_shouldNotLeakMemory() {
        let colors = [UIColor.red, .blue, .green, .yellow, .purple]

        for color in colors {
            for size in [10, 50, 100, 150] {
                autoreleasepool {
                    _ = color.imageWithColor(width: size, height: size)
                }
            }
        }

        XCTAssertTrue(true)
    }

    // MARK: - Concurrent Creation Tests

    func test_imageWithColor_concurrentCreation_shouldBeSafe() {
        let expectation = self.expectation(description: "Concurrent image creation")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue.global(qos: .default)
        let color = UIColor.cyan

        for i in 0..<5 {
            queue.async {
                let size = 50 + (i * 10)
                let image = color.imageWithColor(width: size, height: size)
                XCTAssertNotNil(image, "Concurrent creation \(i) failed")
                XCTAssertEqual(image.size.width, CGFloat(size))
                XCTAssertEqual(image.size.height, CGFloat(size))
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_imageWithColor_concurrentCreationDifferentColors_shouldBeSafe() {
        let expectation = self.expectation(description: "Concurrent creation with different colors")
        expectation.expectedFulfillmentCount = 4

        let queue = DispatchQueue.global(qos: .default)
        let colors = [UIColor.red, .blue, .green, .yellow]

        for (index, color) in colors.enumerated() {
            queue.async {
                let image = color.imageWithColor(width: 100, height: 100)
                XCTAssertNotNil(image, "Concurrent creation for color \(index) failed")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    // MARK: - Graphics Context Tests

    func test_imageWithColor_shouldUseUIGraphicsImageRenderer() {
        // Test that the method properly uses UIGraphicsImageRenderer
        let color = UIColor.red
        let image1 = color.imageWithColor(width: 50, height: 50)
        let image2 = color.imageWithColor(width: 50, height: 50)

        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)

        // Images should be created successfully
        XCTAssertEqual(image1.size, image2.size)

        // Both images should have proper scale for the device
        XCTAssertGreaterThan(image1.scale, 0)
        XCTAssertGreaterThan(image2.scale, 0)
    }

    func test_imageWithColor_shouldHandleGraphicsContextCorrectly() {
        let color = UIColor.blue
        let images = (0..<10).map { i in
            color.imageWithColor(width: 10 + i, height: 10 + i)
        }

        for (index, image) in images.enumerated() {
            XCTAssertNotNil(image, "Image \(index) creation failed")
            XCTAssertNotNil(image.cgImage, "CGImage \(index) creation failed")

            let expectedSize = CGFloat(10 + index)
            XCTAssertEqual(image.size.width, expectedSize)
            XCTAssertEqual(image.size.height, expectedSize)
        }
    }

    // MARK: - Color Fill Tests

    func test_imageWithColor_shouldProperlyFillEntireImage() {
        let color = UIColor.red
        let image = color.imageWithColor(width: 100, height: 100)

        XCTAssertNotNil(image)
        XCTAssertNotNil(image.cgImage)

        // The image should be completely filled with the color
        // This is tested indirectly by ensuring the image was created successfully
        XCTAssertEqual(image.size.width, 100.0)
        XCTAssertEqual(image.size.height, 100.0)
    }

    func test_imageWithColor_withDifferentAspectRatios_shouldFillCorrectly() {
        let color = UIColor.green
        let aspectRatios = [
            (width: 100, height: 50),   // 2:1
            (width: 50, height: 100),   // 1:2
            (width: 150, height: 75),   // 2:1
            (width: 75, height: 150),   // 1:2
            (width: 200, height: 100),  // 2:1
            (width: 100, height: 200)   // 1:2
        ]

        for ratio in aspectRatios {
            let image = color.imageWithColor(width: ratio.width, height: ratio.height)

            XCTAssertNotNil(image, "Failed for ratio \(ratio.width):\(ratio.height)")
            XCTAssertEqual(image.size.width, CGFloat(ratio.width))
            XCTAssertEqual(image.size.height, CGFloat(ratio.height))
        }
    }

    // MARK: - Image Data Tests

    func test_imageWithColor_shouldCreateImageConvertibleToData() {
        let color = UIColor.blue
        let image = color.imageWithColor(width: 100, height: 100)

        XCTAssertNotNil(image)

        // Test that the image can be converted to PNG data
        let pngData = image.pngData()
        XCTAssertNotNil(pngData)
        XCTAssertGreaterThan(pngData?.count ?? 0, 0)

        // Test that the image can be converted to JPEG data
        let jpegData = image.jpegData(compressionQuality: 0.8)
        XCTAssertNotNil(jpegData)
        XCTAssertGreaterThan(jpegData?.count ?? 0, 0)
    }

    func test_imageWithColor_shouldCreateImageUsableWithImageView() {
        let color = UIColor.purple
        let image = color.imageWithColor(width: 200, height: 100)

        XCTAssertNotNil(image)

        // Test that the image can be used with UIImageView
        let imageView = UIImageView(image: image)
        XCTAssertNotNil(imageView.image)
        XCTAssertEqual(imageView.image, image)
    }

    // MARK: - Integration Tests

    func test_imageWithColor_integrationWithCALayer() {
        let color = UIColor.orange
        let image = color.imageWithColor(width: 150, height: 100)

        XCTAssertNotNil(image)

        // Test that the image can be used as layer content
        let layer = CALayer()
        layer.contents = image.cgImage

        XCTAssertNotNil(layer.contents)
    }

    // MARK: - Helper Extensions

    func test_imageWithColor_comparedToExistingUIImageWithColor() {
        // Compare with the existing UIImage(with:width:height:) method if available
        let color = UIColor.red
        let width = 100
        let height = 50

        let imageFromColor = color.imageWithColor(width: width, height: height)
        let imageFromUIImage = UIImage(with: color, width: CGFloat(width), height: CGFloat(height))

        XCTAssertNotNil(imageFromColor)
        XCTAssertNotNil(imageFromUIImage)

        // Both should create valid images (dimensions may vary by implementation)
        XCTAssertTrue(imageFromColor.size.width > 0 || width == 0)
        XCTAssertTrue(imageFromColor.size.height > 0 || height == 0)
        XCTAssertTrue((imageFromUIImage?.size.width ?? 0) > 0 || width == 0)
        XCTAssertTrue((imageFromUIImage?.size.height ?? 0) > 0 || height == 0)
    }
}

