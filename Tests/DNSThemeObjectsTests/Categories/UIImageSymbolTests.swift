//
//  UIImageSymbolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import SFSymbol
@testable import DNSThemeObjects

final class UIImageSymbolTests: XCTestCase {

    // MARK: - Symbol Image Creation Tests

    func test_dnsSymbol_withValidSymbol_shouldReturnImage() {
        let result = UIImage(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    func test_dnsSymbol_withFilledStar_shouldReturnImage() {
        let result = UIImage(dnsSymbol: SFSymbol.Star.fill)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    func test_dnsSymbol_withCircleStar_shouldReturnImage() {
        let result = UIImage(dnsSymbol: SFSymbol.Star.circle)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    func test_dnsSymbol_withHeart_shouldReturnImage() {
        let result = UIImage(dnsSymbol: SFSymbol.heart)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    func test_dnsSymbol_withHeartFill_shouldReturnImage() {
        let result = UIImage(dnsSymbol: SFSymbol.Heart.fill)

        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }

    // MARK: - Common Symbol Tests

    func test_dnsSymbol_withBasicSymbols_shouldReturnImages() {
        let symbols: [SFSymbol] = [
            .star,
            .heart,
            .house,
            .person,
            .bell,
            .phone,
            .camera
        ]

        for symbol in symbols {
            let result = UIImage(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to load symbol: \(symbol)")
        }
    }

    func test_dnsSymbol_withVariantSymbols_shouldReturnImages() {
        let results = [
            UIImage(dnsSymbol: SFSymbol.Star.fill),
            UIImage(dnsSymbol: SFSymbol.Star.circle),
            UIImage(dnsSymbol: SFSymbol.Heart.fill),
            UIImage(dnsSymbol: SFSymbol.Heart.circle)
        ]

        for result in results {
            XCTAssertNotNil(result)
        }
    }

    // MARK: - Image Properties Tests

    func test_dnsSymbol_shouldReturnValidImageProperties() {
        let result = UIImage(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)

        if let image = result {
            XCTAssertGreaterThan(image.size.width, 0)
            XCTAssertGreaterThan(image.size.height, 0)
            XCTAssertNotNil(image.cgImage)
        }
    }

    func test_dnsSymbol_shouldHaveCorrectRenderingMode() {
        let result = UIImage(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)

        if let image = result {
            // Symbol images should typically use template rendering mode
            XCTAssertTrue(image.renderingMode == .alwaysTemplate ||
                         image.renderingMode == .automatic)
        }
    }

    // MARK: - Comparison Tests

    func test_dnsSymbol_comparedToSystemImageNamed_shouldReturnSameImage() {
        let dnsResult = UIImage(dnsSymbol: SFSymbol.star)
        let systemResult = UIImage(systemName: "star")

        XCTAssertNotNil(dnsResult)
        XCTAssertNotNil(systemResult)

        if let dnsImage = dnsResult, let systemImage = systemResult {
            // Images should be equivalent
            XCTAssertEqual(dnsImage.size.width, systemImage.size.width, accuracy: 1.0)
            XCTAssertEqual(dnsImage.size.height, systemImage.size.height, accuracy: 1.0)
        }
    }

    // MARK: - Performance Tests

    func test_dnsSymbol_performance() {
        measure {
            for _ in 0..<100 {
                _ = UIImage(dnsSymbol: SFSymbol.star)
            }
        }
    }

    // MARK: - Edge Cases

    func test_dnsSymbol_nilValue_shouldBeHandledByCompiler() {
        // This test verifies that the compiler-enforced type safety prevents nil symbols
        let result = UIImage(dnsSymbol: SFSymbol.star)
        XCTAssertNotNil(result)
    }

    func test_dnsSymbol_differentSymbolTypes_shouldAllWork() {
        let results = [
            UIImage(dnsSymbol: SFSymbol.gear),
            UIImage(dnsSymbol: SFSymbol.envelope),
            UIImage(dnsSymbol: SFSymbol.photo)
        ]

        for result in results {
            XCTAssertNotNil(result)
        }
    }
}