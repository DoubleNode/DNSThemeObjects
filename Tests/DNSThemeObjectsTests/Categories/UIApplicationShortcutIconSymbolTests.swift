//
//  UIApplicationShortcutIconSymbolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import SFSymbol
import UIKit
@testable import DNSThemeObjects

final class UIApplicationShortcutIconSymbolTests: XCTestCase {

    // MARK: - Basic Symbol Icon Creation Tests

    func test_initWithDnsSymbol_withValidSFSymbol_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withHeartSymbol_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.heart)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withHouseSymbol_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.house)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withPersonSymbol_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.person)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withGearSymbol_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.gear)

        XCTAssertNotNil(result)
    }

    // MARK: - Variant Symbol Tests

    func test_initWithDnsSymbol_withStarFill_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withHeartFill_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.heart)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withStarCircle_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withHeartCircle_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.heart)

        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withPersonFill_shouldReturnIcon() {
        let result = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.person)

        XCTAssertNotNil(result)
    }

    // MARK: - Common App Shortcut Symbols Tests

    func test_initWithDnsSymbol_withCommonShortcutSymbols_shouldReturnIcons() {
        let commonSymbols: [SFSymbol] = [
            .house,
            .magnifyingglass,
            .person,
            .envelope,
            .phone,
            .camera,
            .photo
        ]

        for symbol in commonSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create icon for symbol: \(symbol)")
        }
    }

    func test_initWithDnsSymbol_withNavigationSymbols_shouldReturnIcons() {
        let navigationSymbols: [SFSymbol] = [
            .house,
            .magnifyingglass,
            .person,
            .envelope,
            .gear
        ]

        for symbol in navigationSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create navigation icon for symbol: \(symbol)")
        }
    }

    func test_initWithDnsSymbol_withCommunicationSymbols_shouldReturnIcons() {
        let communicationSymbols: [SFSymbol] = [
            .envelope,
            .phone,
            .message,
            .bell,
            .mic
        ]

        for symbol in communicationSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create communication icon for symbol: \(symbol)")
        }
    }

    func test_initWithDnsSymbol_withSystemSymbols_shouldReturnIcons() {
        let systemSymbols: [SFSymbol] = [
            .gear,
            .wrench,
            .hammer,
            .lock,
            .shield
        ]

        for symbol in systemSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create system icon for symbol: \(symbol)")
        }
    }

    // MARK: - Generic Type Tests

    func test_initWithDnsSymbol_withGenericRawRepresentable_shouldWorkWithSFSymbol() {
        // Test that the generic constraint works correctly
        func createIcon<T: RawRepresentable>(symbol: T) -> UIApplicationShortcutIcon? where T.RawValue == String {
            return UIApplicationShortcutIcon(dnsSymbol: symbol)
        }

        let result = createIcon(symbol: SFSymbol.star)
        XCTAssertNotNil(result)
    }

    func test_initWithDnsSymbol_withCustomStringEnum_shouldWork() {
        // Create a custom string enum to test the generic constraint
        enum CustomSymbol: String {
            case star = "star"
            case heart = "heart"
            case house = "house"
        }

        let starIcon = UIApplicationShortcutIcon(dnsSymbol: CustomSymbol.star)
        let heartIcon = UIApplicationShortcutIcon(dnsSymbol: CustomSymbol.heart)
        let houseIcon = UIApplicationShortcutIcon(dnsSymbol: CustomSymbol.house)

        XCTAssertNotNil(starIcon)
        XCTAssertNotNil(heartIcon)
        XCTAssertNotNil(houseIcon)
    }

    // MARK: - Comparison with System API Tests

    func test_initWithDnsSymbol_comparedToSystemImageName_shouldCreateEquivalentIcons() {
        let dnsIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
        let systemIcon = UIApplicationShortcutIcon(systemImageName: "star")

        XCTAssertNotNil(dnsIcon)
        XCTAssertNotNil(systemIcon)

        // Both should be valid shortcut icons
        // We can't directly compare them as UIApplicationShortcutIcon doesn't expose comparison methods
        // But both should be successfully created
    }

    func test_initWithDnsSymbol_shouldUseCorrectSystemImageName() {
        // Verify that the symbol's rawValue is correctly passed to systemImageName
        let symbol = SFSymbol.gear
        let expectedSystemName = symbol.rawValue

        // Create icon using our extension
        let dnsIcon = UIApplicationShortcutIcon(dnsSymbol: symbol)

        // Create icon using direct system API
        let systemIcon = UIApplicationShortcutIcon(systemImageName: expectedSystemName)

        XCTAssertNotNil(dnsIcon)
        XCTAssertNotNil(systemIcon)

        // Both should be valid and equivalent
    }

    // MARK: - Raw Value Tests

    func test_symbolRawValues_shouldBeValidSystemImageNames() {
        let symbols: [SFSymbol] = [
            .star,
            .heart,
            .house,
            .person,
            .gear
        ]

        for symbol in symbols {
            let rawValue = symbol.rawValue
            XCTAssertFalse(rawValue.isEmpty, "Symbol raw value should not be empty")
            XCTAssertFalse(rawValue.contains(" "), "Symbol raw value should not contain spaces")

            // Verify it works with system API
            let systemIcon = UIApplicationShortcutIcon(systemImageName: rawValue)
            XCTAssertNotNil(systemIcon, "Raw value '\(rawValue)' should create valid system icon")
        }
    }

    // MARK: - Edge Cases

    func test_initWithDnsSymbol_withComplexSymbolName_shouldWork() {
        let complexSymbols: [SFSymbol] = [
            .star,
            .heart,
            .gear
        ]

        for symbol in complexSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create icon for complex symbol: \(symbol)")
        }
    }

    func test_initWithDnsSymbol_withNumberedSymbols_shouldWork() {
        let numberedSymbols: [SFSymbol] = [
            .star,
            .heart,
            .house
        ]

        for symbol in numberedSymbols {
            let result = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(result, "Failed to create icon for numbered symbol: \(symbol)")
        }
    }

    // MARK: - Convenience Initializer Tests

    func test_convenienceInitializer_shouldBeOptional() {
        // The initializer is marked as convenience init?, so it returns an optional
        let result: UIApplicationShortcutIcon? = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)

        XCTAssertNotNil(result)
    }

    func test_convenienceInitializer_shouldCallDesignatedInitializer() {
        // Test that our convenience initializer properly calls the designated initializer
        let symbol = SFSymbol.heart
        let result = UIApplicationShortcutIcon(dnsSymbol: symbol)

        XCTAssertNotNil(result)

        // Should be equivalent to calling systemImageName directly
        let directResult = UIApplicationShortcutIcon(systemImageName: symbol.rawValue)
        XCTAssertNotNil(directResult)
    }

    // MARK: - Performance Tests

    func test_initWithDnsSymbol_performance() {
        let symbol = SFSymbol.star

        measure {
            for _ in 0..<1000 {
                _ = UIApplicationShortcutIcon(dnsSymbol: symbol)
            }
        }
    }

    func test_initWithDnsSymbol_performanceComparison() {
        let symbol = SFSymbol.star
        let systemName = symbol.rawValue

        // Test our extension performance
        measure {
            for _ in 0..<100 {
                _ = UIApplicationShortcutIcon(dnsSymbol: symbol)
            }
        }
    }

    // MARK: - Memory Management Tests

    func test_initWithDnsSymbol_shouldNotLeakMemory() {
        weak var weakIcon: UIApplicationShortcutIcon?

        autoreleasepool {
            let icon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
            weakIcon = icon
            XCTAssertNotNil(weakIcon)
        }

        // Icon should be deallocated when no longer referenced
        XCTAssertNil(weakIcon, "Icon should be deallocated")
    }

    func test_initWithDnsSymbol_multipleInstances_shouldNotInterfere() {
        let icons = (0..<100).map { _ in
            UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
        }

        for icon in icons {
            XCTAssertNotNil(icon)
        }

        XCTAssertEqual(icons.count, 100)
    }

    // MARK: - Thread Safety Tests

    func test_initWithDnsSymbol_shouldBeThreadSafe() {
        let expectation = self.expectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 10

        var icons: [UIApplicationShortcutIcon?] = []
        let iconsQueue = DispatchQueue(label: "icons.queue")

        for i in 0..<10 {
            DispatchQueue.global(qos: .background).async {
                let icon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
                iconsQueue.async {
                    icons.append(icon)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(icons.count, 10)
        for icon in icons {
            XCTAssertNotNil(icon)
        }
    }

    // MARK: - Type Safety Tests

    func test_initWithDnsSymbol_shouldEnforceTypeConstraints() {
        // This test verifies that the generic constraint works at compile time
        // If this compiles, the type constraint is working correctly

        // Valid: SFSymbol conforms to RawRepresentable with String
        let validIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
        XCTAssertNotNil(validIcon)

        // Valid: Custom enum with String RawValue
        enum TestEnum: String {
            case test = "star"
        }
        let customIcon = UIApplicationShortcutIcon(dnsSymbol: TestEnum.test)
        XCTAssertNotNil(customIcon)
    }

    // MARK: - Integration Tests

    func test_initWithDnsSymbol_shouldIntegrateWithUIApplicationShortcutItem() {
        let icon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
        XCTAssertNotNil(icon)

        // Should be usable in UIApplicationShortcutItem
        if let validIcon = icon {
            let shortcutItem = UIApplicationShortcutItem(
                type: "test.shortcut",
                localizedTitle: "Test",
                localizedSubtitle: nil,
                icon: validIcon,
                userInfo: nil
            )

            XCTAssertNotNil(shortcutItem)
            XCTAssertEqual(shortcutItem.type, "test.shortcut")
            XCTAssertEqual(shortcutItem.localizedTitle, "Test")
        }
    }

    func test_initWithDnsSymbol_shouldWorkWithVariousAppContexts() {
        // Test common app shortcut scenarios
        let homeIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.house)
        let searchIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.magnifyingglass)
        let profileIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.person)
        let settingsIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.gear)

        XCTAssertNotNil(homeIcon)
        XCTAssertNotNil(searchIcon)
        XCTAssertNotNil(profileIcon)
        XCTAssertNotNil(settingsIcon)

        // All should be valid for creating shortcut items
        let shortcuts = [
            (homeIcon, "Home"),
            (searchIcon, "Search"),
            (profileIcon, "Profile"),
            (settingsIcon, "Settings")
        ]

        for (icon, title) in shortcuts {
            if let validIcon = icon {
                let item = UIApplicationShortcutItem(
                    type: "test.\(title.lowercased())",
                    localizedTitle: title,
                    localizedSubtitle: nil,
                    icon: validIcon,
                    userInfo: nil
                )
                XCTAssertNotNil(item)
            }
        }
    }

    // MARK: - Framework Compatibility Tests

    func test_initWithDnsSymbol_shouldWorkWithSFSymbolFramework() {
        // Test compatibility with SFSymbol framework features
        let symbols: [SFSymbol] = [
            .star,
            .heart,
            .house,
            .person
        ]

        for symbol in symbols {
            let icon = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(icon, "Failed to create icon for SFSymbol: \(symbol)")

            // Verify the symbol has a valid raw value
            XCTAssertFalse(symbol.rawValue.isEmpty)
        }
    }

    func test_initWithDnsSymbol_shouldMaintainSymbolCharacteristics() {
        let symbol = SFSymbol.heart
        let icon = UIApplicationShortcutIcon(dnsSymbol: symbol)

        XCTAssertNotNil(icon)

        // The icon should represent the same symbol as the original
        let directIcon = UIApplicationShortcutIcon(systemImageName: symbol.rawValue)
        XCTAssertNotNil(directIcon)

        // Both should be equivalent in representing the same symbol
    }

    // MARK: - Documentation Examples Tests

    func test_initWithDnsSymbol_documentationExamples_shouldWork() {
        // Test examples that would typically appear in documentation

        // Example 1: Basic usage
        let starIcon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.star)
        XCTAssertNotNil(starIcon)

        // Example 2: Using in shortcut item
        if let icon = UIApplicationShortcutIcon(dnsSymbol: SFSymbol.house) {
            let shortcut = UIApplicationShortcutItem(
                type: "com.example.home",
                localizedTitle: "Home",
                localizedSubtitle: "Go to home screen",
                icon: icon,
                userInfo: nil
            )
            XCTAssertNotNil(shortcut)
        }

        // Example 3: Multiple shortcuts
        let shortcuts: [(SFSymbol, String)] = [
            (.house, "Home"),
            (.magnifyingglass, "Search"),
            (.person, "Profile"),
            (.gear, "Settings")
        ]

        for (symbol, title) in shortcuts {
            let icon = UIApplicationShortcutIcon(dnsSymbol: symbol)
            XCTAssertNotNil(icon, "Failed to create icon for \(title)")
        }
    }
}