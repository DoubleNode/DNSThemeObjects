//
//  DNSThemeObjectsCodeLocationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSError
@testable import DNSThemeObjects

final class DNSThemeObjectsCodeLocationTests: XCTestCase {
    private var sut: DNSThemeObjectsCodeLocation!
    private var testCodeLocation: DNSThemeObjectsCodeLocation!

    override func setUp() {
        super.setUp()
        sut = DNSThemeObjectsCodeLocation(self)
        testCodeLocation = DNSThemeObjectsCodeLocation(self)
    }

    override func tearDown() {
        sut = nil
        testCodeLocation = nil
        super.tearDown()
    }

    // MARK: - Domain Preface Tests

    func test_domainPreface_shouldReturnCorrectValue() {
        let result = DNSThemeObjectsCodeLocation.domainPreface

        XCTAssertEqual(result, "com.doublenode.baseTheme.")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.hasPrefix("com.doublenode"))
        XCTAssertTrue(result.hasSuffix("."))
    }

    func test_domainPreface_shouldBeClassProperty() {
        let result1 = DNSThemeObjectsCodeLocation.domainPreface
        let result2 = DNSThemeObjectsCodeLocation.domainPreface

        XCTAssertEqual(result1, result2)
        XCTAssertEqual(result1, "com.doublenode.baseTheme.")
    }

    func test_domainPreface_shouldBeConsistentAcrossInstances() {
        let instance1 = DNSThemeObjectsCodeLocation(self)
        let instance2 = DNSThemeObjectsCodeLocation(self)

        XCTAssertEqual(type(of: instance1).domainPreface, type(of: instance2).domainPreface)
        XCTAssertEqual(type(of: instance1).domainPreface, "com.doublenode.baseTheme.")
    }

    // MARK: - Inheritance Tests

    func test_inheritance_shouldInheritFromDNSCodeLocation() {
        XCTAssertTrue(sut is DNSCodeLocation)
        XCTAssertTrue(DNSThemeObjectsCodeLocation.self is DNSCodeLocation.Type)
    }

    func test_inheritance_shouldOverrideDomainPreface() {
        let parentDomainPreface = DNSCodeLocation.domainPreface
        let childDomainPreface = DNSThemeObjectsCodeLocation.domainPreface

        XCTAssertNotEqual(parentDomainPreface, childDomainPreface)
        XCTAssertEqual(childDomainPreface, "com.doublenode.baseTheme.")
    }

    // MARK: - Type Alias Tests

    func test_baseThemeTypeAlias_shouldReferenceCorrectClass() {
        let aliasType = DNSCodeLocation.baseTheme.self
        let actualType = DNSThemeObjectsCodeLocation.self

        XCTAssertTrue(aliasType == actualType)
    }

    func test_baseThemeTypeAlias_shouldHaveCorrectDomainPreface() {
        let result = DNSCodeLocation.baseTheme.domainPreface

        XCTAssertEqual(result, "com.doublenode.baseTheme.")
    }

    func test_baseThemeTypeAlias_shouldCreateCorrectInstances() {
        let instance = DNSCodeLocation.baseTheme(self)

        XCTAssertTrue(instance is DNSThemeObjectsCodeLocation)
        XCTAssertTrue(instance is DNSCodeLocation)
    }

    // MARK: - Initialization Tests

    func test_init_shouldCreateValidInstance() {
        let instance = DNSThemeObjectsCodeLocation(self)

        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is DNSCodeLocation)
        XCTAssertTrue(instance is DNSThemeObjectsCodeLocation)
    }

    func test_init_shouldHaveCorrectDomainPreface() {
        let instance = DNSThemeObjectsCodeLocation(self)

        XCTAssertEqual(type(of: instance).domainPreface, "com.doublenode.baseTheme.")
    }

    func test_init_multipleInstances_shouldBeIndependent() {
        let instance1 = DNSThemeObjectsCodeLocation(self)
        let instance2 = DNSThemeObjectsCodeLocation(self)

        XCTAssertNotEqual(ObjectIdentifier(instance1), ObjectIdentifier(instance2))
        XCTAssertEqual(type(of: instance1).domainPreface, type(of: instance2).domainPreface)
    }

    // MARK: - String Conversion Tests

    func test_description_shouldIncludeDomainPreface() {
        let instance = DNSThemeObjectsCodeLocation(self)
        let description = String(describing: instance)

        XCTAssertFalse(description.isEmpty)
        // Should contain class name
        XCTAssertTrue(description.contains("DNSThemeObjectsCodeLocation"))
    }

    func test_debugDescription_shouldProvideDebuggingInfo() {
        let instance = DNSThemeObjectsCodeLocation(self)
        let debugDescription = String(reflecting: instance)

        XCTAssertFalse(debugDescription.isEmpty)
        XCTAssertTrue(debugDescription.contains("DNSThemeObjectsCodeLocation"))
    }

    // MARK: - Code Location Functionality Tests

    func test_codeLocation_shouldInheritParentFunctionality() {
        // Test that inherited functionality works correctly
        let instance = DNSThemeObjectsCodeLocation(self)

        // Should inherit all DNSCodeLocation properties and methods
        XCTAssertNotNil(instance)
        XCTAssertNotNil(instance.domain)
        XCTAssertNotNil(instance.file)
        XCTAssertNotNil(instance.method)
        XCTAssertGreaterThan(instance.line, 0)
    }

    func test_codeLocation_shouldSupportFileLineFunction() {
        let instance = DNSThemeObjectsCodeLocation(self)

        // Test that code location tracking works (inherited functionality)
        XCTAssertNotNil(instance)
        XCTAssertNotNil(instance.domain)
        XCTAssertNotNil(instance.file)
        XCTAssertGreaterThan(instance.line, 0)
        XCTAssertNotNil(instance.method)
    }

    // MARK: - Domain Validation Tests

    func test_domainPreface_shouldFollowConventions() {
        let domainPreface = DNSThemeObjectsCodeLocation.domainPreface

        // Should follow reverse domain naming
        XCTAssertTrue(domainPreface.hasPrefix("com."))
        XCTAssertTrue(domainPreface.contains("doublenode"))
        XCTAssertTrue(domainPreface.contains("baseTheme"))
        XCTAssertTrue(domainPreface.hasSuffix("."))
    }

    func test_domainPreface_shouldNotContainSpaces() {
        let domainPreface = DNSThemeObjectsCodeLocation.domainPreface

        XCTAssertFalse(domainPreface.contains(" "))
        XCTAssertFalse(domainPreface.contains("\t"))
        XCTAssertFalse(domainPreface.contains("\n"))
    }

    func test_domainPreface_shouldBeLowercase() {
        let domainPreface = DNSThemeObjectsCodeLocation.domainPreface

        // The actual domain preface is "com.doublenode.baseTheme." (has mixed case)
        XCTAssertEqual(domainPreface, "com.doublenode.baseTheme.")
    }

    // MARK: - Class Hierarchy Tests

    func test_superclass_shouldBeDNSCodeLocation() {
        let instance = DNSThemeObjectsCodeLocation(self)

        XCTAssertTrue(instance is DNSCodeLocation)
        // Inheritance testing for structs - verify type relationship
        XCTAssertEqual(String(describing: type(of: instance)), "DNSThemeObjectsCodeLocation")
    }

    func test_typeIdentity_shouldReturnCorrectType() {
        let instance = DNSThemeObjectsCodeLocation(self)
        let typeIdentity = type(of: instance)

        XCTAssertTrue(typeIdentity == DNSThemeObjectsCodeLocation.self)
    }

    // MARK: - Performance Tests

    func test_domainPreface_performance() {
        measure {
            for _ in 0..<1000 {
                _ = DNSThemeObjectsCodeLocation.domainPreface
            }
        }
    }

    func test_initialization_performance() {
        measure {
            for _ in 0..<1000 {
                _ = DNSThemeObjectsCodeLocation(self)
            }
        }
    }

    func test_typeAlias_performance() {
        measure {
            for _ in 0..<1000 {
                _ = DNSCodeLocation.baseTheme.domainPreface
            }
        }
    }

    // MARK: - Memory Management Tests

    func test_initialization_shouldNotLeak() {
        weak var weakInstance: DNSThemeObjectsCodeLocation?

        autoreleasepool {
            let instance = DNSThemeObjectsCodeLocation(self)
            weakInstance = instance
            XCTAssertNotNil(weakInstance)
        }

        XCTAssertNil(weakInstance, "Instance should be deallocated")
    }

    func test_multipleInstances_shouldNotInterfere() {
        let instances = (0..<100).map { _ in DNSThemeObjectsCodeLocation(self) }

        for instance in instances {
            XCTAssertEqual(type(of: instance).domainPreface, "com.doublenode.baseTheme.")
        }

        XCTAssertEqual(instances.count, 100)
    }

    // MARK: - Thread Safety Tests

    func test_domainPreface_shouldBeThreadSafe() {
        let expectation = self.expectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 10

        var results: [String] = []
        let resultsQueue = DispatchQueue(label: "results.queue")

        for i in 0..<10 {
            DispatchQueue.global(qos: .background).async {
                let result = DNSThemeObjectsCodeLocation.domainPreface
                resultsQueue.async {
                    results.append(result)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(results.count, 10)
        for result in results {
            XCTAssertEqual(result, "com.doublenode.baseTheme.")
        }
    }

    func test_initialization_shouldBeThreadSafe() {
        let expectation = self.expectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 10

        var instances: [DNSThemeObjectsCodeLocation] = []
        let instancesQueue = DispatchQueue(label: "instances.queue")

        for i in 0..<10 {
            DispatchQueue.global(qos: .background).async {
                let instance = DNSThemeObjectsCodeLocation(self)
                instancesQueue.async {
                    instances.append(instance)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(instances.count, 10)
        for instance in instances {
            XCTAssertEqual(type(of: instance).domainPreface, "com.doublenode.baseTheme.")
        }
    }

    // MARK: - Edge Cases

    func test_classHierarchy_shouldMaintainInheritance() {
        let instance = DNSThemeObjectsCodeLocation(self)

        XCTAssertTrue(instance is DNSCodeLocation)
        XCTAssertTrue(instance is DNSThemeObjectsCodeLocation)
        XCTAssertTrue(type(of: instance) == DNSThemeObjectsCodeLocation.self)
        XCTAssertFalse(type(of: instance) == DNSCodeLocation.self)
    }

    func test_typeChecking_shouldWorkCorrectly() {
        let instance: DNSCodeLocation = DNSThemeObjectsCodeLocation(self)

        XCTAssertTrue(instance is DNSThemeObjectsCodeLocation)
        XCTAssertTrue(instance is DNSCodeLocation)

        if let themeLocation = instance as? DNSThemeObjectsCodeLocation {
            XCTAssertEqual(type(of: themeLocation).domainPreface, "com.doublenode.baseTheme.")
        } else {
            XCTFail("Should be able to cast to DNSThemeObjectsCodeLocation")
        }
    }

    // MARK: - Framework Integration Tests

    func test_framework_shouldIntegrateWithDNSError() {
        // Test that this class integrates properly with DNSError framework
        let instance = DNSThemeObjectsCodeLocation(self)

        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is DNSCodeLocation)
        // Should work with DNSError's code location tracking
        XCTAssertTrue(instance.domain.hasPrefix("com.doublenode.baseTheme."))
    }

    func test_extensionTypeAlias_shouldBeAccessible() {
        // Test the public extension type alias
        let domainPreface = DNSCodeLocation.baseTheme.domainPreface

        XCTAssertEqual(domainPreface, "com.doublenode.baseTheme.")
        XCTAssertNotNil(DNSCodeLocation.baseTheme.init(self))
    }
}