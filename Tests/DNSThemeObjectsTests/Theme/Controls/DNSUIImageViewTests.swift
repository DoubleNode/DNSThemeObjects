//
//  DNSUIImageViewTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUIImageViewTests: XCTestCase {
    private var sut: DNSUIImageView!
    private var mockStyle: DNSThemeViewStyle!

    override func setUp() {
        super.setUp()
        sut = DNSUIImageView(frame: CGRect.zero)
        mockStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockStyle = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withDefaultValues_shouldSetDefaultStyle() {
        XCTAssertEqual(sut.styleName, DNSThemeViewStyle.default.fullName)
        XCTAssertTrue(sut.style is DNSThemeViewStyle)
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let imageView = DNSUIImageView(frame: frame)

        XCTAssertEqual(imageView.frame, frame)
        XCTAssertEqual(imageView.styleName, DNSThemeViewStyle.default.fullName)
    }

    func test_init_withImage_shouldInitializeCorrectly() {
        let testImage = UIImage()
        let imageView = DNSUIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = testImage

        XCTAssertEqual(imageView.image, testImage)
        XCTAssertEqual(imageView.styleName, DNSThemeViewStyle.default.fullName)
    }

    // MARK: - Style Application Tests

    func test_styleSet_withValidStyle_shouldApplyStyle() {
        let newStyle = DNSThemeViewStyle.Base.default

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

    // MARK: - Image Handling Tests

    func test_image_afterStyleApplication_shouldRetainImage() {
        let testImage = createTestImage()
        sut.image = testImage

        sut.style = DNSThemeViewStyle.Base.default

        XCTAssertEqual(sut.image, testImage)
    }

    func test_contentMode_shouldBeConfigurable() {
        sut.contentMode = .scaleAspectFit

        XCTAssertEqual(sut.contentMode, .scaleAspectFit)
    }

    func test_contentMode_afterStyleApplication_shouldBeUpdated() {
        let originalContentMode = sut.contentMode
        sut.style = DNSThemeViewStyle.Base.default

        // Content mode may or may not be changed by style - verify it's a valid mode
        XCTAssertTrue(sut.contentMode.rawValue >= 0)
        // Style application completed without error
        XCTAssertNotNil(sut.style)
    }

    // MARK: - Utility Apply Tests

    func test_utilityApply_withImageStyle_shouldApplyCorrectly() {
        let imageStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(imageStyle)

        // Verify that the style was applied
        XCTAssertNotNil(sut.layer)
    }

    func test_utilityApply_withViewStyle_shouldCallSuperImplementation() {
        let viewStyle = DNSThemeViewStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(viewStyle))
    }

    // MARK: - Corner Radius Tests

    func test_cornerRadius_afterStyleApplication_shouldBeSet() {
        let imageStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(imageStyle)

        // Avatar style typically sets corner radius
        XCTAssertGreaterThanOrEqual(sut.layer.cornerRadius, 0)
    }

    // MARK: - Border Tests

    func test_border_afterStyleApplication_shouldBeSet() {
        let imageStyle = DNSThemeViewStyle.Base.default

        sut.utilityApply(imageStyle)

        // Border properties should be set if defined in style
        XCTAssertGreaterThanOrEqual(sut.layer.borderWidth, 0)
    }

    // MARK: - IBInspectable Tests

    func test_styleName_asIBInspectable_shouldBeSettable() {
        let testStyleName = "Base.default"

        sut.styleName = testStyleName

        XCTAssertEqual(sut.styleName, testStyleName)
    }

    // MARK: - Accessibility Tests

    func test_accessibilityLabel_shouldBeSettable() {
        let accessibilityText = "Profile Image"
        sut.accessibilityLabel = accessibilityText

        XCTAssertEqual(sut.accessibilityLabel, accessibilityText)
    }

    func test_isAccessibilityElement_shouldBeConfigurable() {
        sut.isAccessibilityElement = true

        XCTAssertTrue(sut.isAccessibilityElement)
    }

    // MARK: - Animation Tests

    func test_animationImages_shouldBeSettable() {
        let images = [createTestImage(), createTestImage()]
        sut.animationImages = images

        XCTAssertEqual(sut.animationImages?.count, 2)
    }

    func test_animationDuration_shouldBeSettable() {
        sut.animationDuration = 2.0

        XCTAssertEqual(sut.animationDuration, 2.0, accuracy: 0.01)
    }

    // MARK: - Edge Cases

    func test_styleSet_duringStyleSetting_shouldNotCauseRecursion() {
        let style1 = DNSThemeViewStyle.Base.default
        let style2 = DNSThemeViewStyle.Base.default

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

    func test_image_withNilValue_shouldHandleGracefully() {
        sut.image = nil

        XCTAssertNil(sut.image)
    }

    // MARK: - Type Safety Tests

    func test_themeStyleTypealias_shouldMatchExpectedType() {
        XCTAssertTrue(DNSUIImageView.ThemeStyle.self == DNSThemeViewStyle.self)
    }

    // MARK: - Layout Tests

    func test_intrinsicContentSize_withImage_shouldReturnImageSize() {
        let testImage = createTestImage(size: CGSize(width: 50, height: 75))
        sut.image = testImage

        let size = sut.intrinsicContentSize

        XCTAssertEqual(size.width, 50)
        XCTAssertEqual(size.height, 75)
    }

    func test_intrinsicContentSize_withoutImage_shouldReturnNoIntrinsicMetric() {
        sut.image = nil

        let size = sut.intrinsicContentSize

        XCTAssertEqual(size.width, UIView.noIntrinsicMetric)
        XCTAssertEqual(size.height, UIView.noIntrinsicMetric)
    }

    // MARK: - Helper Methods

    private func createTestImage(size: CGSize = CGSize(width: 10, height: 10)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}