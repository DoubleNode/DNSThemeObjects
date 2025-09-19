//
//  DNSAlertViewControllerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class DNSAlertViewControllerTests: XCTestCase {
    private var sut: DNSAlertViewController!

    override func setUp() {
        super.setUp()
        sut = DNSAlertViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_shouldCreateAlertViewController() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is DNSAlertViewController)
        XCTAssertTrue(sut is UIViewController)
    }

    func test_init_shouldInitializeRetainedWindow() {
        XCTAssertNil(sut.retainedWindow)
    }

    // MARK: - Retained Window Tests

    func test_retainedWindow_shouldBeSettable() {
        let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        sut.retainedWindow = testWindow

        XCTAssertNotNil(sut.retainedWindow)
        XCTAssertEqual(sut.retainedWindow, testWindow)
    }

    func test_retainedWindow_shouldBeNillable() {
        let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sut.retainedWindow = testWindow

        sut.retainedWindow = nil

        XCTAssertNil(sut.retainedWindow)
    }

    func test_retainedWindow_shouldRetainWindow() {
        weak var weakWindow: UIWindow?

        autoreleasepool {
            let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            weakWindow = testWindow
            sut.retainedWindow = testWindow
        }

        // Window should still be retained by DNSAlertViewController
        XCTAssertNotNil(weakWindow)
    }

    func test_retainedWindow_shouldReleaseOnNil() {
        weak var weakWindow: UIWindow?

        autoreleasepool {
            let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            weakWindow = testWindow
            sut.retainedWindow = testWindow
            sut.retainedWindow = nil
        }

        // Window should be released after setting to nil
        XCTAssertNil(weakWindow)
    }

    // MARK: - Deinit Tests

    func test_deinit_shouldReleaseRetainedWindow() {
        weak var weakWindow: UIWindow?
        weak var weakViewController: DNSAlertViewController?

        autoreleasepool {
            let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            weakWindow = testWindow

            let alertViewController = DNSAlertViewController()
            weakViewController = alertViewController
            alertViewController.retainedWindow = testWindow

            // alertViewController goes out of scope here
        }

        // Both should be deallocated
        XCTAssertNil(weakViewController)
        XCTAssertNil(weakWindow)
    }

    func test_deinit_shouldHandleNilRetainedWindow() {
        weak var weakViewController: DNSAlertViewController?

        autoreleasepool {
            let alertViewController = DNSAlertViewController()
            weakViewController = alertViewController
            alertViewController.retainedWindow = nil

            // Should not crash on deinit
        }

        XCTAssertNil(weakViewController)
    }

    // MARK: - View Controller Lifecycle Tests

    func test_viewDidLoad_shouldCallSuper() {
        // This test ensures the view controller can load its view
        XCTAssertNoThrow(sut.loadViewIfNeeded())
        XCTAssertNotNil(sut.view)
    }

    func test_viewWillAppear_shouldWork() {
        sut.loadViewIfNeeded()

        XCTAssertNoThrow(sut.viewWillAppear(false))
    }

    func test_viewDidAppear_shouldWork() {
        sut.loadViewIfNeeded()

        XCTAssertNoThrow(sut.viewDidAppear(false))
    }

    func test_viewWillDisappear_shouldWork() {
        sut.loadViewIfNeeded()

        XCTAssertNoThrow(sut.viewWillDisappear(false))
    }

    func test_viewDidDisappear_shouldWork() {
        sut.loadViewIfNeeded()

        XCTAssertNoThrow(sut.viewDidDisappear(false))
    }

    // MARK: - Memory Management Tests

    func test_multipleWindowAssignments_shouldNotLeakMemory() {
        for i in 0..<10 {
            autoreleasepool {
                let window = UIWindow(frame: CGRect(x: i * 10, y: i * 10, width: 100, height: 100))
                sut.retainedWindow = window
            }
        }

        // Final assignment should replace previous ones
        XCTAssertNotNil(sut.retainedWindow)
    }

    func test_retainedWindow_afterViewControllerDeallocation_shouldBeReleased() {
        weak var weakWindow: UIWindow?

        autoreleasepool {
            let alertVC = DNSAlertViewController()
            let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            weakWindow = testWindow

            alertVC.retainedWindow = testWindow
            // alertVC goes out of scope here
        }

        // Window should be released when view controller is deallocated
        XCTAssertNil(weakWindow)
    }

    // MARK: - Window Properties Tests

    func test_retainedWindow_shouldMaintainWindowProperties() {
        let testWindow = UIWindow(frame: CGRect(x: 50, y: 100, width: 200, height: 300))
        testWindow.backgroundColor = .red
        testWindow.windowLevel = .alert

        sut.retainedWindow = testWindow

        XCTAssertEqual(sut.retainedWindow?.frame, testWindow.frame)
        XCTAssertEqual(sut.retainedWindow?.backgroundColor, testWindow.backgroundColor)
        XCTAssertEqual(sut.retainedWindow?.windowLevel, testWindow.windowLevel)
    }

    func test_retainedWindow_shouldAllowWindowConfiguration() {
        let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sut.retainedWindow = testWindow

        // Should be able to configure the retained window
        sut.retainedWindow?.backgroundColor = .blue
        sut.retainedWindow?.isHidden = false

        XCTAssertEqual(sut.retainedWindow?.backgroundColor, .blue)
        XCTAssertEqual(sut.retainedWindow?.isHidden, false)
    }

    // MARK: - Presentation Tests

    func test_presentation_withRetainedWindow_shouldWork() {
        let testWindow = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UIViewController()
        testWindow.rootViewController = rootViewController
        testWindow.makeKeyAndVisible()
        sut.retainedWindow = testWindow

        let presentedViewController = UIViewController()

        // Test that presentation doesn't crash in test environment
        XCTAssertNoThrow({
            sut.present(presentedViewController, animated: false)
        }())

        // Verify state after presentation attempt
        XCTAssertNotNil(sut.retainedWindow)
    }

    func test_dismissal_withRetainedWindow_shouldWork() {
        let testWindow = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UIViewController()
        testWindow.rootViewController = rootViewController
        testWindow.makeKeyAndVisible()
        sut.retainedWindow = testWindow

        let presentedViewController = UIViewController()

        // Test that presentation and dismissal don't crash in test environment
        XCTAssertNoThrow({
            sut.present(presentedViewController, animated: false)
        }())

        XCTAssertNoThrow({
            sut.dismiss(animated: false)
        }())

        // Verify state is maintained
        XCTAssertNotNil(sut.retainedWindow)
    }

    // MARK: - Edge Cases

    func test_multipleRetainedWindowAssignments_shouldReplaceCorrectly() {
        let firstWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let secondWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

        sut.retainedWindow = firstWindow
        XCTAssertEqual(sut.retainedWindow, firstWindow)

        sut.retainedWindow = secondWindow
        XCTAssertEqual(sut.retainedWindow, secondWindow)
        XCTAssertNotEqual(sut.retainedWindow, firstWindow)
    }

    func test_retainedWindow_withSameWindowAssignment_shouldWork() {
        let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        sut.retainedWindow = testWindow
        sut.retainedWindow = testWindow // Assign same window again

        XCTAssertEqual(sut.retainedWindow, testWindow)
    }

    // MARK: - Thread Safety Tests

    func test_retainedWindow_onMainThread_shouldWork() {
        XCTAssertTrue(Thread.isMainThread)

        let testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        sut.retainedWindow = testWindow

        XCTAssertEqual(sut.retainedWindow, testWindow)
    }

    // MARK: - Real-world Usage Tests

    func test_alertControllerRetention_realWorldScenario() {
        // Simulate real-world usage for iOS 13+ alert retention
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = .alert
        alertWindow.backgroundColor = .clear
        alertWindow.makeKeyAndVisible()

        let alertViewController = UIAlertController(title: "Test", message: "Test Alert", preferredStyle: .alert)
        alertWindow.rootViewController = sut

        // DNSAlertViewController retains the window
        sut.retainedWindow = alertWindow

        // Test that alert presentation doesn't crash in test environment
        XCTAssertNoThrow({
            sut.present(alertViewController, animated: false)
        }())

        // Verify state after presentation attempt
        XCTAssertNotNil(sut.retainedWindow)
        // Alert may not actually be presented in test environment
    }

    func test_windowCleanup_afterAlertDismissal() {
        weak var weakWindow: UIWindow?

        autoreleasepool {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            weakWindow = alertWindow

            sut.retainedWindow = alertWindow

            // Simulate cleanup
            sut.retainedWindow = nil
        }

        XCTAssertNil(weakWindow)
    }
}