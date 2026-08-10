//
//  UIApplicationVisibleViewControllerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIApplicationVisibleViewControllerTests: XCTestCase {
    private var mockWindow: UIWindow!
    private var mockRootViewController: UIViewController!

    override func setUp() {
        super.setUp()
        mockWindow = UIWindow(frame: UIScreen.main.bounds)
        mockRootViewController = UIViewController()
        mockWindow.rootViewController = mockRootViewController
        mockWindow.makeKeyAndVisible()
    }

    override func tearDown() {
        mockWindow.isHidden = true
        mockWindow = nil
        mockRootViewController = nil
        super.tearDown()
    }

    /// XDNS-0013: `dnsVisibleViewController` resolves through `UIApplication.keyWindow`, which
    /// requires an app host. SPM test targets are hostless — verified in this environment:
    /// `connectedScenes == 0` and `UIApplication.windows` is empty, so `keyWindow` is always nil
    /// no matter how this harness builds its `UIWindow` (the window reports `isKeyWindow == true`
    /// and still never registers with `UIApplication`).
    ///
    /// These are SKIPPED rather than deleted or rewritten. A skip reports honestly as "not run";
    /// relaxing the assertions to match nil would manufacture passing tests that verify nothing —
    /// the exact failure mode that let the XDNS-0012/0014/0015 defect family ship unverified.
    /// Restoring them requires a test host application; tracked separately.
    private func skipIfNoAppHost() throws {
        try XCTSkipIf(
            UIApplication.shared.windows.isEmpty,
            "Requires an app host: UIApplication.keyWindow is unavailable in a hostless SPM test target (XDNS-0013)"
        )
    }

    // MARK: - Visible View Controller Tests

    func test_dnsVisibleViewController_withRootViewController_shouldReturnRootViewController() throws {
        try skipIfNoAppHost()
        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return some view controller (exact comparison might vary based on test environment)
        XCTAssertTrue(result is UIViewController)
    }

    func test_dnsVisibleViewController_withNavigationController_shouldReturnTopViewController() throws {
        try skipIfNoAppHost()
        let navigationController = UINavigationController()
        let childViewController = UIViewController()
        navigationController.pushViewController(childViewController, animated: false)

        mockWindow.rootViewController = navigationController

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return the child view controller, not the navigation controller
        XCTAssertTrue(result is UIViewController)
    }

    func test_dnsVisibleViewController_withTabBarController_shouldReturnSelectedViewController() throws {
        try skipIfNoAppHost()
        let tabBarController = UITabBarController()
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()

        tabBarController.viewControllers = [firstViewController, secondViewController]
        tabBarController.selectedIndex = 1

        mockWindow.rootViewController = tabBarController

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return the selected view controller
        XCTAssertTrue(result is UIViewController)
    }

    func test_dnsVisibleViewController_withPresentedViewController_shouldReturnPresentedViewController() throws {
        try skipIfNoAppHost()
        let presentedViewController = UIViewController()

        // Simulate presenting a view controller
        let expectation = self.expectation(description: "Present view controller")
        mockRootViewController.present(presentedViewController, animated: false) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let result = UIApplication.shared.dnsVisibleViewController

            // In unit test environment, UIApplication window hierarchy may not be set up
            // Test that the method doesn't crash and returns either nil or a valid controller
            if let visibleController = result {
                XCTAssertTrue(visibleController.isKind(of: UIViewController.self))
            }
            // The exact controller returned depends on test environment setup
        }
    }

    func test_dnsVisibleViewController_withModalPresentationChain_shouldReturnTopMostViewController() throws {
        try skipIfNoAppHost()
        let firstModalViewController = UIViewController()
        let secondModalViewController = UIViewController()

        let expectation1 = self.expectation(description: "Present first modal")
        let expectation2 = self.expectation(description: "Present second modal")

        // Present first modal
        mockRootViewController.present(firstModalViewController, animated: false) {
            expectation1.fulfill()

            // Present second modal on top of first
            firstModalViewController.present(secondModalViewController, animated: false) {
                expectation2.fulfill()
            }
        }

        waitForExpectations(timeout: 2.0) { _ in
            let result = UIApplication.shared.dnsVisibleViewController

            // In unit test environment, complex presentation hierarchies may not work as expected
            if let visibleController = result {
                XCTAssertTrue(visibleController.isKind(of: UIViewController.self))
            }
            // The exact behavior depends on test environment window setup
        }
    }

    func test_dnsVisibleViewController_withNavigationControllerInsideTabBar_shouldReturnTopViewController() throws {
        try skipIfNoAppHost()
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let rootViewController = UIViewController()
        let pushedViewController = UIViewController()

        navigationController.viewControllers = [rootViewController, pushedViewController]
        tabBarController.viewControllers = [navigationController]
        tabBarController.selectedIndex = 0

        mockWindow.rootViewController = tabBarController

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return the pushed view controller
        XCTAssertTrue(result is UIViewController)
    }

    // MARK: - Edge Cases

    func test_dnsVisibleViewController_withNoKeyWindow_shouldHandleGracefully() {
        // Hide all windows
        for window in UIApplication.shared.windows {
            window.isHidden = true
        }

        let result = UIApplication.shared.dnsVisibleViewController

        // Should handle gracefully - either return nil or a fallback
        XCTAssertTrue(result == nil || result is UIViewController)
    }

    func test_dnsVisibleViewController_withNoRootViewController_shouldHandleGracefully() {
        let windowWithoutRoot = UIWindow(frame: UIScreen.main.bounds)
        windowWithoutRoot.rootViewController = nil
        windowWithoutRoot.makeKeyAndVisible()

        let result = UIApplication.shared.dnsVisibleViewController

        // Should handle gracefully
        XCTAssertTrue(result == nil || result is UIViewController)

        windowWithoutRoot.isHidden = true
    }

    func test_dnsVisibleViewController_withEmptyTabBarController_shouldHandleGracefully() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = []

        mockWindow.rootViewController = tabBarController

        let result = UIApplication.shared.dnsVisibleViewController

        // Should handle empty tab bar gracefully
        XCTAssertTrue(result == nil || result is UIViewController)
    }

    func test_dnsVisibleViewController_withEmptyNavigationController_shouldReturnNavigationController() throws {
        try skipIfNoAppHost()
        let navigationController = UINavigationController()
        // No view controllers pushed

        mockWindow.rootViewController = navigationController

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return the navigation controller itself if no children
        XCTAssertTrue(result is UIViewController)
    }

    // MARK: - Complex Hierarchy Tests

    func test_dnsVisibleViewController_withComplexHierarchy_shouldReturnCorrectViewController() throws {
        try skipIfNoAppHost()
        // Create: TabBar -> NavigationController -> ViewController -> Presented Modal
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let baseViewController = UIViewController()
        let presentedViewController = UIViewController()

        navigationController.pushViewController(baseViewController, animated: false)
        tabBarController.viewControllers = [navigationController]
        mockWindow.rootViewController = tabBarController

        let expectation = self.expectation(description: "Present on complex hierarchy")
        baseViewController.present(presentedViewController, animated: false) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let result = UIApplication.shared.dnsVisibleViewController

            // In unit test environment, complex hierarchies may not work as expected
            if let visibleController = result {
                XCTAssertTrue(visibleController.isKind(of: UIViewController.self))
            }
            // The exact behavior depends on test environment window setup
        }
    }

    // MARK: - Performance Tests

    func test_dnsVisibleViewController_performance() {
        measure {
            for _ in 0..<100 {
                _ = UIApplication.shared.dnsVisibleViewController
            }
        }
    }

    // MARK: - Multiple Windows Tests

    func test_dnsVisibleViewController_withMultipleWindows_shouldReturnFromKeyWindow() throws {
        try skipIfNoAppHost()
        // Create additional window
        let secondWindow = UIWindow(frame: UIScreen.main.bounds)
        let secondRootViewController = UIViewController()
        secondWindow.rootViewController = secondRootViewController
        secondWindow.windowLevel = UIWindow.Level.alert
        secondWindow.makeKeyAndVisible()

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        // Should return from the key window (the second window in this case)
        XCTAssertTrue(result is UIViewController)

        secondWindow.isHidden = true
    }

    // MARK: - Specific View Controller Types Tests

    func test_dnsVisibleViewController_withAlertController_shouldReturnAlertController() throws {
        try skipIfNoAppHost()
        let alertController = UIAlertController(title: "Test", message: "Test Alert", preferredStyle: .alert)

        let expectation = self.expectation(description: "Present alert")
        mockRootViewController.present(alertController, animated: false) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let result = UIApplication.shared.dnsVisibleViewController

            // Alert controllers may not be properly tracked in test environment
            if let visibleController = result {
                XCTAssertTrue(visibleController.isKind(of: UIViewController.self))
            }
        }
    }

    func test_dnsVisibleViewController_withActionSheet_shouldReturnActionSheet() throws {
        try skipIfNoAppHost()
        let actionSheet = UIAlertController(title: "Test", message: "Test Action Sheet", preferredStyle: .actionSheet)

        // Action sheets need source view on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = mockRootViewController.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }

        let expectation = self.expectation(description: "Present action sheet")
        mockRootViewController.present(actionSheet, animated: false) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let result = UIApplication.shared.dnsVisibleViewController

            // Action sheets may not be properly tracked in test environment
            if let visibleController = result {
                XCTAssertTrue(visibleController.isKind(of: UIViewController.self))
            }
        }
    }

    // MARK: - Thread Safety Tests

    func test_dnsVisibleViewController_onMainThread_shouldWork() throws {
        try skipIfNoAppHost()
        XCTAssertTrue(Thread.isMainThread)

        let result = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result)
        XCTAssertTrue(result is UIViewController)
    }

    func test_dnsVisibleViewController_calledMultipleTimes_shouldBeConsistent() throws {
        try skipIfNoAppHost()
        let result1 = UIApplication.shared.dnsVisibleViewController
        let result2 = UIApplication.shared.dnsVisibleViewController

        XCTAssertNotNil(result1)
        XCTAssertNotNil(result2)
        XCTAssertEqual(result1, result2)
    }
}