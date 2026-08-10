//
//  UIViewControllerTopViewControllerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIViewControllerTopViewControllerTests: XCTestCase {

    /// XDNS-0013: several tests below fake a modal hierarchy with
    /// `setValue(_:forKey: "presentedViewController")`. `presentedViewController` is a read-only
    /// UIViewController property and is not KVC-settable, so those calls raise
    /// `NSUnknownKeyException` — "this class is not key value coding-compliant for the key
    /// presentedViewController". The technique never worked; it was simply never executed, because
    /// this target had not compiled under the current toolchain.
    ///
    /// Building the hierarchy honestly requires real `present(_:animated:)`, which needs a running
    /// app host — unavailable in a hostless SPM test target (verified: `connectedScenes == 0`,
    /// `UIApplication.windows` empty).
    ///
    /// These are SKIPPED rather than left raising or rewritten around. A skip reports honestly as
    /// "not run"; substituting weaker assertions would manufacture coverage that verifies nothing.
    /// Restoring them requires a test host application; tracked separately.
    private func skipNeedsRealPresentation() throws {
        throw XCTSkip(
            "Requires real modal presentation via an app host: presentedViewController is read-only and not KVC-settable (XDNS-0013)"
        )
    }

    // MARK: - Basic View Controller Tests

    func test_dnsTopViewController_withSimpleViewController_shouldReturnSelf() {
        let viewController = UIViewController()

        let topViewController = viewController.dnsTopViewController

        XCTAssertEqual(topViewController, viewController)
        XCTAssertTrue(topViewController === viewController)
    }

    func test_dnsTopViewController_withCustomViewController_shouldReturnSelf() {
        let customViewController = CustomViewController()

        let topViewController = customViewController.dnsTopViewController

        XCTAssertEqual(topViewController, customViewController)
        XCTAssertTrue(topViewController === customViewController)
    }

    func test_dnsTopViewController_withTableViewController_shouldReturnSelf() {
        let tableViewController = UITableViewController()

        let topViewController = tableViewController.dnsTopViewController

        XCTAssertEqual(topViewController, tableViewController)
        XCTAssertTrue(topViewController === tableViewController)
    }

    func test_dnsTopViewController_withCollectionViewController_shouldReturnSelf() {
        let layout = UICollectionViewFlowLayout()
        let collectionViewController = UICollectionViewController(collectionViewLayout: layout)

        let topViewController = collectionViewController.dnsTopViewController

        XCTAssertEqual(topViewController, collectionViewController)
        XCTAssertTrue(topViewController === collectionViewController)
    }

    // MARK: - Navigation Controller Tests

    func test_dnsTopViewController_withNavigationController_noVisibleController_shouldReturnNavigationController() {
        let navigationController = UINavigationController()

        let topViewController = navigationController.dnsTopViewController

        XCTAssertEqual(topViewController, navigationController)
        XCTAssertTrue(topViewController === navigationController)
    }

    func test_dnsTopViewController_withNavigationController_withRootController_shouldReturnRootController() {
        let rootController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootController)

        let topViewController = navigationController.dnsTopViewController

        XCTAssertEqual(topViewController, rootController)
        XCTAssertTrue(topViewController === rootController)
    }

    func test_dnsTopViewController_withNavigationController_withPushedController_shouldReturnTopController() {
        let rootController = UIViewController()
        let pushedController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.pushViewController(pushedController, animated: false)

        let topViewController = navigationController.dnsTopViewController

        XCTAssertEqual(topViewController, pushedController)
        XCTAssertTrue(topViewController === pushedController)
    }

    func test_dnsTopViewController_withNavigationController_multiplePushedControllers_shouldReturnTopmost() {
        let rootController = UIViewController()
        let secondController = UIViewController()
        let thirdController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.pushViewController(secondController, animated: false)
        navigationController.pushViewController(thirdController, animated: false)

        let topViewController = navigationController.dnsTopViewController

        XCTAssertEqual(topViewController, thirdController)
        XCTAssertTrue(topViewController === thirdController)
    }

    // XDNS-0013: this previously nested a UINavigationController inside another
    // UINavigationController, which UIKit forbids — it raised
    // "Pushing a navigation controller is not supported (NSInvalidArgumentException)".
    // The test therefore asserted behaviour for a hierarchy that cannot exist.
    // Rewritten to a legal nested-container arrangement (tab bar -> navigation -> leaf) so the
    // actual intent — that dnsTopViewController recurses through nested containers to the deepest
    // controller — is still covered.
    func test_dnsTopViewController_withNestedContainerControllers_shouldReturnDeepestController() {
        let deepController = UIViewController()
        let innerNavController = UINavigationController(rootViewController: deepController)
        let outerTabController = UITabBarController()
        outerTabController.viewControllers = [innerNavController]
        outerTabController.selectedIndex = 0

        let topViewController = outerTabController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    // MARK: - Tab Bar Controller Tests

    func test_dnsTopViewController_withTabBarController_noSelectedController_shouldReturnTabBarController() {
        let tabBarController = UITabBarController()

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, tabBarController)
        XCTAssertTrue(topViewController === tabBarController)
    }

    func test_dnsTopViewController_withTabBarController_withSelectedController_shouldReturnSelectedController() {
        let firstController = UIViewController()
        let secondController = UIViewController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstController, secondController]
        tabBarController.selectedIndex = 0

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, firstController)
        XCTAssertTrue(topViewController === firstController)
    }

    func test_dnsTopViewController_withTabBarController_differentSelectedIndex_shouldReturnCorrectController() {
        let firstController = UIViewController()
        let secondController = UIViewController()
        let thirdController = UIViewController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstController, secondController, thirdController]
        tabBarController.selectedIndex = 2

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, thirdController)
        XCTAssertTrue(topViewController === thirdController)
    }

    func test_dnsTopViewController_withTabBarController_withNavigationController_shouldReturnDeepestController() {
        let deepController = UIViewController()
        let navigationController = UINavigationController(rootViewController: deepController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        tabBarController.selectedIndex = 0

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    func test_dnsTopViewController_withNestedTabBarControllers_shouldReturnDeepestController() {
        let deepController = UIViewController()
        let innerTabController = UITabBarController()
        innerTabController.viewControllers = [deepController]
        innerTabController.selectedIndex = 0

        let outerTabController = UITabBarController()
        outerTabController.viewControllers = [innerTabController]
        outerTabController.selectedIndex = 0

        let topViewController = outerTabController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    // MARK: - Presented View Controller Tests

    func test_dnsTopViewController_withPresentedController_shouldReturnPresentedController() throws {
        try skipNeedsRealPresentation()
        let baseController = UIViewController()
        let presentedController = UIViewController()

        // Simulate presentation
        baseController.setValue(presentedController, forKey: "presentedViewController")

        let topViewController = baseController.dnsTopViewController

        XCTAssertEqual(topViewController, presentedController)
        XCTAssertTrue(topViewController === presentedController)
    }

    func test_dnsTopViewController_withChainedPresentedControllers_shouldReturnTopmost() throws {
        try skipNeedsRealPresentation()
        let baseController = UIViewController()
        let firstPresentedController = UIViewController()
        let secondPresentedController = UIViewController()

        // Simulate presentation chain
        baseController.setValue(firstPresentedController, forKey: "presentedViewController")
        firstPresentedController.setValue(secondPresentedController, forKey: "presentedViewController")

        let topViewController = baseController.dnsTopViewController

        XCTAssertEqual(topViewController, secondPresentedController)
        XCTAssertTrue(topViewController === secondPresentedController)
    }

    func test_dnsTopViewController_withPresentedNavigationController_shouldReturnDeepestController() throws {
        try skipNeedsRealPresentation()
        let baseController = UIViewController()
        let deepController = UIViewController()
        let presentedNavController = UINavigationController(rootViewController: deepController)

        // Simulate presentation
        baseController.setValue(presentedNavController, forKey: "presentedViewController")

        let topViewController = baseController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    func test_dnsTopViewController_withPresentedTabBarController_shouldReturnDeepestController() throws {
        try skipNeedsRealPresentation()
        let baseController = UIViewController()
        let deepController = UIViewController()
        let presentedTabController = UITabBarController()
        presentedTabController.viewControllers = [deepController]
        presentedTabController.selectedIndex = 0

        // Simulate presentation
        baseController.setValue(presentedTabController, forKey: "presentedViewController")

        let topViewController = baseController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    // MARK: - Complex Hierarchy Tests

    func test_dnsTopViewController_withComplexHierarchy_shouldReturnDeepestController() throws {
        try skipNeedsRealPresentation()
        // Create a complex hierarchy: TabBar -> Navigation -> Base -> Presented Navigation -> Deep Controller
        let deepController = UIViewController()
        let presentedNavController = UINavigationController(rootViewController: deepController)

        let baseController = UIViewController()
        baseController.setValue(presentedNavController, forKey: "presentedViewController")

        let rootNavController = UINavigationController(rootViewController: baseController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [rootNavController]
        tabBarController.selectedIndex = 0

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    func test_dnsTopViewController_withMixedContainerTypes_shouldReturnDeepestController() throws {
        try skipNeedsRealPresentation()
        // Tab -> Navigation -> Regular -> Presented Tab -> Navigation -> Deep
        let deepController = UIViewController()
        let deepNavController = UINavigationController(rootViewController: deepController)

        let presentedTabController = UITabBarController()
        presentedTabController.viewControllers = [deepNavController]
        presentedTabController.selectedIndex = 0

        let middleController = UIViewController()
        middleController.setValue(presentedTabController, forKey: "presentedViewController")

        let rootNavController = UINavigationController(rootViewController: middleController)

        let rootTabController = UITabBarController()
        rootTabController.viewControllers = [rootNavController]
        rootTabController.selectedIndex = 0

        let topViewController = rootTabController.dnsTopViewController

        XCTAssertEqual(topViewController, deepController)
        XCTAssertTrue(topViewController === deepController)
    }

    // MARK: - Edge Cases

    func test_dnsTopViewController_withEmptyNavigationStack_shouldReturnNavigationController() {
        let navigationController = UINavigationController()
        navigationController.setViewControllers([], animated: false)

        let topViewController = navigationController.dnsTopViewController

        XCTAssertEqual(topViewController, navigationController)
        XCTAssertTrue(topViewController === navigationController)
    }

    func test_dnsTopViewController_withEmptyTabBarViewControllers_shouldReturnTabBarController() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = []

        let topViewController = tabBarController.dnsTopViewController

        XCTAssertEqual(topViewController, tabBarController)
        XCTAssertTrue(topViewController === tabBarController)
    }

    func test_dnsTopViewController_withInvalidSelectedIndex_shouldReturnTabBarController() {
        let controller = UIViewController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [controller]
        tabBarController.selectedIndex = 5 // Invalid index

        let topViewController = tabBarController.dnsTopViewController

        // With invalid index, behavior may vary - should return a valid view controller
        XCTAssertNotNil(topViewController)
        XCTAssertTrue(topViewController is UIViewController)
        // The exact controller returned depends on implementation details
    }

    // MARK: - Memory Management Tests

    func test_dnsTopViewController_memoryManagement_shouldNotRetainControllers() {
        weak var weakController: UIViewController?

        autoreleasepool {
            let controller = UIViewController()
            weakController = controller
            _ = controller.dnsTopViewController
        }

        // The computed property should not retain the view controller
        XCTAssertNil(weakController)
    }

    func test_dnsTopViewController_complexHierarchy_memoryManagement() {
        weak var weakDeepController: UIViewController?

        autoreleasepool {
            let deepController = UIViewController()
            weakDeepController = deepController

            let navController = UINavigationController(rootViewController: deepController)
            let tabController = UITabBarController()
            tabController.viewControllers = [navController]
            tabController.selectedIndex = 0

            _ = tabController.dnsTopViewController
        }

        // Should not retain the deep controller
        XCTAssertNil(weakDeepController)
    }

    // MARK: - Performance Tests

    func test_dnsTopViewController_performance_simpleHierarchy() {
        let controller = UIViewController()

        measure {
            for _ in 0..<1000 {
                _ = controller.dnsTopViewController
            }
        }
    }

    func test_dnsTopViewController_performance_complexHierarchy() {
        let deepController = UIViewController()
        let navController = UINavigationController(rootViewController: deepController)
        let tabController = UITabBarController()
        tabController.viewControllers = [navController]
        tabController.selectedIndex = 0

        measure {
            for _ in 0..<1000 {
                _ = tabController.dnsTopViewController
            }
        }
    }

    func test_dnsTopViewController_performance_veryDeepHierarchy() {
        // Create a very deep hierarchy
        var currentController: UIViewController = UIViewController()
        for _ in 0..<10 {
            let navController = UINavigationController(rootViewController: currentController)
            let tabController = UITabBarController()
            tabController.viewControllers = [navController]
            tabController.selectedIndex = 0
            currentController = tabController
        }

        measure {
            for _ in 0..<100 {
                _ = currentController.dnsTopViewController
            }
        }
    }

    // MARK: - Concurrent Access Tests

    func test_dnsTopViewController_concurrentAccess_shouldBeSafe() {
        let controller = UIViewController()
        let expectation = self.expectation(description: "Concurrent access to dnsTopViewController")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue.global(qos: .default)

        for i in 0..<5 {
            queue.async {
                let topController = controller.dnsTopViewController
                XCTAssertEqual(topController, controller, "Concurrent access \(i) failed")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    // MARK: - Type Safety Tests

    func test_dnsTopViewController_typeChecking_shouldUseIsOperator() {
        // Test that the method properly uses type checking
        let navigationController = UINavigationController()
        let tabBarController = UITabBarController()
        let regularController = UIViewController()

        // These tests verify the type checking logic
        XCTAssertTrue(navigationController is UINavigationController)
        XCTAssertTrue(tabBarController is UITabBarController)
        XCTAssertFalse(regularController is UINavigationController)
        XCTAssertFalse(regularController is UITabBarController)

        // Verify the method works correctly with type checking
        _ = navigationController.dnsTopViewController
        _ = tabBarController.dnsTopViewController
        _ = regularController.dnsTopViewController
    }

    // MARK: - Recursion Safety Tests

    func test_dnsTopViewController_recursionSafety_shouldNotCauseInfiniteLoop() {
        // Create a simple hierarchy to test recursion
        let controller = UIViewController()
        let navController = UINavigationController(rootViewController: controller)

        // This should not cause infinite recursion
        let topController = navController.dnsTopViewController

        XCTAssertEqual(topController, controller)
        XCTAssertTrue(topController === controller)
    }

    func test_dnsTopViewController_withCircularPresentation_shouldHandleGracefully() throws {
        try skipNeedsRealPresentation()
        // Note: In practice, UIKit prevents true circular presentations,
        // but this tests the robustness of the algorithm
        let controller1 = UIViewController()
        let controller2 = UIViewController()

        // Simulate a presentation chain
        controller1.setValue(controller2, forKey: "presentedViewController")

        let topController = controller1.dnsTopViewController

        XCTAssertEqual(topController, controller2)
        XCTAssertTrue(topController === controller2)
    }
}

// MARK: - Helper Classes

private class CustomViewController: UIViewController {
    // Custom view controller for testing
}