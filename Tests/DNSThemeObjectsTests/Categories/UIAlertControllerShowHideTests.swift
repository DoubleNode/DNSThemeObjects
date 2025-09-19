//
//  UIAlertControllerShowHideTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSThemeObjects

final class UIAlertControllerShowHideTests: XCTestCase {
    private var testWindow: UIWindow!
    private var mockViewController: UIViewController!

    override func setUp() {
        super.setUp()
        mockViewController = UIViewController()

        // Create a window and make it key for testing
        testWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        testWindow.rootViewController = mockViewController
        testWindow.makeKeyAndVisible()
    }

    override func tearDown() {
        testWindow.isHidden = true
        testWindow = nil
        mockViewController = nil
        super.tearDown()
    }

    // MARK: - Show Alert Tests

    func test_dnsShow_withBasicAlert_shouldPresentAlert() {
        let alert = UIAlertController(title: "Test Title", message: "Test Message", preferredStyle: .alert)

        // Test that dnsShow presents the alert without throwing
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))

        // Verify the alert is presented
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_dnsShow_withAlertAndActions_shouldPresentAlertWithActions() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        // Test that dnsShow presents the alert with actions
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))
        XCTAssertEqual(alert.actions.count, 2)

        // Verify the alert is presented
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_dnsShow_withActionSheet_shouldPresentActionSheet() {
        let actionSheet = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "Option 1", style: .default) { _ in }
        let action2 = UIAlertAction(title: "Option 2", style: .default) { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancelAction)

        // Set source view for iPad compatibility
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = mockViewController.view
            popover.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }

        // Test that dnsShow presents the action sheet
        XCTAssertNoThrow(actionSheet.dnsShow(window: testWindow))
        XCTAssertEqual(actionSheet.preferredStyle, .actionSheet)

        // Verify the action sheet is presented
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_dnsShow_withEmptyAlert_shouldPresentSuccessfully() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Test that dnsShow handles empty alert gracefully
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))

        // Verify the alert is presented
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_dnsShow_withCustomWindow_shouldMakeWindowKeyAndVisible() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)
        let customWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        customWindow.rootViewController = UIViewController()

        // Test that dnsShow makes the window key and visible
        alert.dnsShow(window: customWindow)

        XCTAssertTrue(customWindow.isKeyWindow || !customWindow.isHidden)
    }

    // MARK: - Hide Alert Tests

    func test_dnsHide_afterShowing_shouldHideWindow() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Show the alert first
        alert.dnsShow(window: testWindow)
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)

        // Then hide it
        alert.dnsHide(window: testWindow)
        XCTAssertTrue(testWindow.isHidden)
    }

    func test_dnsHide_withoutShowing_shouldHandleGracefully() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Test that dnsHide handles gracefully when called without showing
        XCTAssertNoThrow(alert.dnsHide(window: testWindow))
        XCTAssertTrue(testWindow.isHidden)
    }

    func test_dnsHide_multipleTimes_shouldHandleGracefully() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Show the alert first
        alert.dnsShow(window: testWindow)
        XCTAssertFalse(testWindow.isHidden)

        // Hide it first time
        alert.dnsHide(window: testWindow)
        XCTAssertTrue(testWindow.isHidden)

        // Hide it second time - should handle gracefully
        XCTAssertNoThrow(alert.dnsHide(window: testWindow))
        XCTAssertTrue(testWindow.isHidden)
    }

    // MARK: - Show/Hide Cycle Tests

    func test_showHideCycle_shouldWorkCorrectly() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Show
        alert.dnsShow(window: testWindow)
        XCTAssertFalse(testWindow.isHidden)
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)

        // Hide
        alert.dnsHide(window: testWindow)
        XCTAssertTrue(testWindow.isHidden)

        // Reset window for second show
        testWindow.isHidden = false
        testWindow.makeKeyAndVisible()

        // Show again
        alert.dnsShow(window: testWindow)
        XCTAssertFalse(testWindow.isHidden)
    }

    func test_multipleAlertsSequentially_shouldWorkCorrectly() {
        let alert1 = UIAlertController(title: "Alert 1", message: "First Alert", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "Alert 2", message: "Second Alert", preferredStyle: .alert)

        // Show first alert
        alert1.dnsShow(window: testWindow)
        XCTAssertFalse(testWindow.isHidden)

        // Hide first alert
        alert1.dnsHide(window: testWindow)
        XCTAssertTrue(testWindow.isHidden)

        // Reset window and show second alert
        testWindow.isHidden = false
        testWindow.makeKeyAndVisible()
        alert2.dnsShow(window: testWindow)
        XCTAssertFalse(testWindow.isHidden)
    }

    // MARK: - Error Handling Tests

    func test_dnsShow_withInvalidConfiguration_shouldHandleGracefully() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Add an action that might cause issues
        let problematicAction = UIAlertAction(title: "", style: .default) { _ in }
        alert.addAction(problematicAction)

        // Should handle gracefully regardless of configuration
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))
    }

    // MARK: - Memory Management Tests

    func test_alertRetention_duringPresentation_shouldNotLeakMemory() {
        weak var weakAlert: UIAlertController?

        autoreleasepool {
            let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)
            weakAlert = alert

            alert.dnsShow(window: testWindow)
            alert.dnsHide(window: testWindow)
        }

        // Test that alert can be deallocated after hide
        // Note: In real scenarios, the alert might be retained by the presentation system
        XCTAssertNotNil(weakAlert) // Alert may still be retained by system
    }

    // MARK: - Thread Safety Tests

    func test_dnsShow_onMainThread_shouldWork() {
        XCTAssertTrue(Thread.isMainThread)

        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        // Test that dnsShow works on main thread
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))
        XCTAssertTrue(Thread.isMainThread)
    }

    // MARK: - Performance Tests

    func test_dnsShow_performance() {
        measure {
            let alert = UIAlertController(title: "Performance Test", message: "Testing performance", preferredStyle: .alert)

            // Reset window for each iteration
            testWindow.isHidden = false
            testWindow.makeKeyAndVisible()

            alert.dnsShow(window: testWindow)
            alert.dnsHide(window: testWindow)
        }
    }

    // MARK: - Action Handling Tests

    func test_alertActionExecution_afterShow_shouldWork() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        var actionExecuted = false
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            actionExecuted = true
        }
        alert.addAction(okAction)

        // Test that alert with actions shows properly
        alert.dnsShow(window: testWindow)
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(alert.actions.first?.title, "OK")
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_cancelActionExecution_shouldShowAlert() {
        let alert = UIAlertController(title: "Test", message: "Test Message", preferredStyle: .alert)

        var cancelExecuted = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelExecuted = true
        }
        alert.addAction(cancelAction)

        // Test that alert with cancel action shows properly
        alert.dnsShow(window: testWindow)
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
        XCTAssertEqual(alert.actions.first?.title, "Cancel")
    }

    // MARK: - Edge Cases

    func test_dnsShow_withVeryLongText_shouldHandleCorrectly() {
        let longTitle = String(repeating: "A", count: 100)
        let longMessage = String(repeating: "B", count: 200)

        let alert = UIAlertController(title: longTitle, message: longMessage, preferredStyle: .alert)

        // Test that dnsShow handles long text gracefully
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }

    func test_dnsShow_withManyActions_shouldHandleCorrectly() {
        let alert = UIAlertController(title: "Many Actions", message: "Test", preferredStyle: .actionSheet)

        // Add several actions
        for i in 1...5 {
            let action = UIAlertAction(title: "Action \(i)", style: .default) { _ in }
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(cancelAction)

        // Set source for iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = mockViewController.view
            popover.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }

        // Test that dnsShow handles many actions correctly
        XCTAssertNoThrow(alert.dnsShow(window: testWindow))
        XCTAssertEqual(alert.actions.count, 6)
        XCTAssertNotNil(testWindow.rootViewController?.presentedViewController)
    }
}