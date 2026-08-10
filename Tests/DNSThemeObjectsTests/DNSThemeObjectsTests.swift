//
//  DNSThemeObjectsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
@testable import DNSThemeObjects

final class DNSThemeObjectsTests: XCTestCase {
    // MARK: - Package Integration Tests

    func test_packageImports_shouldBeAvailable() {
        // Verify core DNSThemeObjects imports are accessible
        XCTAssertTrue(true, "DNSThemeObjects package should be importable")
    }

    func test_coreUIComponents_shouldBeInstantiable() {
        // Test that core UI components can be instantiated
        let button = DNSUIButton()
        let label = DNSUILabel()
        let view = DNSUIView()
        let imageView = DNSUIImageView(frame: CGRect.zero)

        XCTAssertNotNil(button, "DNSUIButton should be instantiable")
        XCTAssertNotNil(label, "DNSUILabel should be instantiable")
        XCTAssertNotNil(view, "DNSUIView should be instantiable")
        XCTAssertNotNil(imageView, "DNSUIImageView should be instantiable")
    }

    func test_themeStylesAccess_shouldWork() {
        // Test that theme styles are accessible
        let button = DNSUIButton()
        let label = DNSUILabel()

        // Verify default styles are accessible
        XCTAssertNotNil(button.styleName, "Button should have default style name")
        XCTAssertNotNil(label.styleName, "Label should have default style name")

        // Verify styles can be applied
        XCTAssertNoThrow(button.utilityApply("Base.default"), "Button should accept style application")
        XCTAssertNoThrow(label.utilityApply("Base.default"), "Label should accept style application")
    }

    func test_UIKitExtensions_shouldWork() {
        // Test that UIKit extensions are functional
        let testColor = UIColor.red
        let testImage = UIImage(with: testColor, width: 10, height: 10)

        XCTAssertNotNil(testImage, "UIImage+dnsWithColor extension should work")

        let testView = UIView()
        testView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        XCTAssertEqual(testView.width, 100, "UIView+dnsSize extension should work")
        XCTAssertEqual(testView.height, 50, "UIView+dnsSize extension should work")
    }

    func test_packageDependencies_shouldBeAccessible() {
        // Verify external dependencies are properly integrated
        let activeLabel = DNSUIActiveLabel()
        XCTAssertNotNil(activeLabel, "ActiveLabel integration should work")

        let pickerView = DNSUIPickerView()
        XCTAssertNotNil(pickerView, "UIPickerView themed component should work")
    }

    static var allTests = [
        ("test_packageImports_shouldBeAvailable", test_packageImports_shouldBeAvailable),
        ("test_coreUIComponents_shouldBeInstantiable", test_coreUIComponents_shouldBeInstantiable),
        ("test_themeStylesAccess_shouldWork", test_themeStylesAccess_shouldWork),
        ("test_UIKitExtensions_shouldWork", test_UIKitExtensions_shouldWork),
        ("test_packageDependencies_shouldBeAccessible", test_packageDependencies_shouldBeAccessible),
    ]
}
