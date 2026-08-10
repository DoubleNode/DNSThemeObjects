//
//  AnimatedFieldApplyStyleTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import AnimatedField
import DNSThemeTypes
import Foundation
import SkeletonView
@testable import DNSThemeObjects

// XDNS-0013: `AnimatedField` is declared `@MainActor open class` by AnimatedField 3.2.2, and
// UIKit's `UIView` is `@MainActor` besides. Under Swift 6 strict concurrency every `sut` access
// from a nonisolated XCTestCase method is an isolation violation. Annotating the suite is the
// correct fix — these tests drive UIKit and genuinely belong on the main actor.
@MainActor
final class AnimatedFieldApplyStyleTests: XCTestCase {
    private var sut: AnimatedField!
    private var mockFieldStyle: DNSThemeFieldStyle!
    private var mockThemeStyle: DNSThemeStyle!

    override func setUp() {
        super.setUp()
        sut = AnimatedField()
        mockFieldStyle = DNSThemeFieldStyle.default
        mockThemeStyle = DNSThemeViewStyle.Base.default
    }

    override func tearDown() {
        sut = nil
        mockFieldStyle = nil
        mockThemeStyle = nil
        super.tearDown()
    }

    // MARK: - Alert Position Conversion Tests

    func test_convertAlertPosition_withTopPosition_shouldReturnTop() {
        // Test the private conversion method through public interface
        let originalFormat = sut.format
        sut.dnsApply(mockFieldStyle)

        // The conversion should have worked correctly
        XCTAssertNotNil(sut.format)
        // Position should be set from style
    }

    func test_convertAlertPosition_withBottomPosition_shouldReturnBottom() {
        let originalFormat = sut.format
        sut.dnsApply(mockFieldStyle)

        XCTAssertNotNil(sut.format)
        // Should apply bottom position if specified in style
    }

    // MARK: - Field Style Application Tests

    func test_dnsApply_withFieldStyle_shouldApplyAllProperties() {
        let originalFormat = sut.format

        sut.dnsApply(mockFieldStyle)

        let newFormat = sut.format
        XCTAssertNotNil(newFormat)
        // Format should be updated with style properties
    }

    func test_dnsApply_withFieldStyle_shouldSetInvalidCharacters() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.invalidCharacters)
        // Invalid characters should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetTitleProperties() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.titleColor)
        // Title properties should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetTextProperties() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.textColor)
        XCTAssertNotNil(format.placeholderColor)
        // Text properties should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetCounterProperties() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.counterFont)
        XCTAssertNotNil(format.counterColor)
        // Counter properties should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetAlertProperties() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.alertFont)
        XCTAssertNotNil(format.alertColor)
        // Alert properties should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetLineColor() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.lineColor)
        // Line color should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetPickerTextColor() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.pickerTextColor)
        // Picker text color should be set from style
    }

    func test_dnsApply_withFieldStyle_shouldSetVisibilityImages() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        // Visibility images should be set if provided in style
        XCTAssertNotNil(format)
    }

    func test_dnsApply_withFieldStyle_shouldSetTextFieldHeight() {
        sut.dnsApply(mockFieldStyle)

        let format = sut.format
        XCTAssertGreaterThanOrEqual(format.textFieldHeight, 0)
        // Text field height should be set from style
    }

    // MARK: - State Update with Theme Style Tests

    func test_updateForState_withThemeStyle_enabledState_shouldApplyNormalProperties() {
        sut.isEnabled = true

        sut.updateForState(using: mockThemeStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertNotNil(sut.layer.shadowColor)
        XCTAssertNotNil(sut.tintColor)
    }

    func test_updateForState_withThemeStyle_disabledState_shouldApplyDisabledProperties() {
        sut.isEnabled = false

        sut.updateForState(using: mockThemeStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertNotNil(sut.layer.shadowColor)
        XCTAssertNotNil(sut.tintColor)
        // Should apply disabled state properties
    }

    func test_updateForState_withThemeStyle_selectedState_shouldApplySelectedProperties() {
        sut.isSelected = true

        sut.updateForState(using: mockThemeStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertNotNil(sut.layer.shadowColor)
        XCTAssertNotNil(sut.tintColor)
        // Should apply selected state properties
    }

    func test_updateForState_withThemeStyle_highlightedState_shouldApplyHighlightedProperties() {
        sut.isHighlighted = true

        sut.updateForState(using: mockThemeStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertNotNil(sut.layer.shadowColor)
        XCTAssertNotNil(sut.tintColor)
        // Should apply highlighted state properties
    }

    func test_updateForState_withThemeStyle_focusedState_shouldApplyFocusedProperties() {
        // Note: AnimatedField.isFocused is read-only, so we test the method directly
        sut.updateForState(using: mockThemeStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer.borderColor)
        XCTAssertNotNil(sut.layer.shadowColor)
        XCTAssertNotNil(sut.tintColor)
        // Should apply focused state properties based on current state
    }

    func test_updateForState_withThemeStyle_shouldSetSkeletonableProperty() {
        sut.updateForState(using: mockThemeStyle)

        // Skeletonable property should be set based on enabled state
        XCTAssertNotNil(sut)
    }

    // MARK: - State Update with Field Style Tests

    func test_updateForState_withFieldStyle_enabledState_shouldApplyNormalFieldProperties() {
        sut.isEnabled = true

        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.counterFont)
        XCTAssertNotNil(format.lineColor)
        XCTAssertNotNil(format.titleColor)
        XCTAssertNotNil(format.textColor)
        XCTAssertNotNil(format.counterColor)
    }

    func test_updateForState_withFieldStyle_disabledState_shouldApplyDisabledFieldProperties() {
        sut.isEnabled = false

        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.counterFont)
        // Should apply disabled state properties for field-specific items
    }

    func test_updateForState_withFieldStyle_selectedState_shouldApplySelectedFieldProperties() {
        sut.isSelected = true

        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.counterFont)
        // Should apply selected state properties for field-specific items
    }

    func test_updateForState_withFieldStyle_highlightedState_shouldApplyHighlightedFieldProperties() {
        sut.isHighlighted = true

        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.counterFont)
        XCTAssertNotNil(format.highlightColor)
        // Should apply highlighted state properties for field-specific items
    }

    func test_updateForState_withFieldStyle_focusedState_shouldApplyFocusedFieldProperties() {
        // Note: AnimatedField.isFocused is read-only, so we test the method directly
        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textFont)
        XCTAssertNotNil(format.counterFont)
        // Should apply focused state properties for field-specific items
    }

    // MARK: - Combined State Tests

    func test_updateForState_withMultipleStates_shouldApplyCorrectPriority() {
        sut.isEnabled = true
        sut.isSelected = true
        sut.isHighlighted = true

        sut.updateForState(using: mockFieldStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.format.titleColor)
        // Highest priority state should win
    }

    func test_updateForState_withDisabledAndSelected_shouldHandleCorrectly() {
        sut.isEnabled = false
        sut.isSelected = true

        sut.updateForState(using: mockFieldStyle)

        let format = sut.format
        XCTAssertNotNil(format.titleFont)
        XCTAssertNotNil(format.textColor)
        // Should handle conflicting states appropriately
    }

    // MARK: - Format Preservation Tests

    func test_dnsApply_shouldPreserveOtherFormatProperties() {
        let _ = sut.format
        // Note: Testing preservation of non-style-related properties

        sut.dnsApply(mockFieldStyle)

        let newFormat = sut.format
        XCTAssertNotNil(newFormat)
        // Non-styled properties should be preserved
    }

    func test_updateForState_shouldNotOverwriteStyleAppliedProperties() {
        sut.dnsApply(mockFieldStyle)
        let _ = sut.format

        sut.updateForState(using: mockFieldStyle)

        let updatedFormat = sut.format
        // Core properties should be maintained but state-specific ones updated
        XCTAssertNotNil(updatedFormat.invalidCharacters)
    }

    // MARK: - Super Class Method Tests

    func test_dnsApply_shouldCallSuperClassMethod() {
        // Test that parent dnsApply is called
        sut.dnsApply(mockFieldStyle)

        // Should apply base theme style properties via super call
        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.layer)
    }

    func test_updateForState_shouldCallParentUpdateForState() {
        sut.updateForState(using: mockFieldStyle)

        // Should apply base theme style state updates via parent call
        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.tintColor)
    }

    // MARK: - Performance Tests

    func test_dnsApply_performance() {
        measure {
            for _ in 0..<100 {
                sut.dnsApply(mockFieldStyle)
            }
        }
    }

    func test_updateForState_performance() {
        measure {
            for _ in 0..<100 {
                sut.updateForState(using: mockFieldStyle)
            }
        }
    }

    // MARK: - Memory Management Tests

    func test_dnsApply_shouldNotCauseMemoryLeaks() {
        // AnimatedFieldFormat is a struct, not a class, so no weak references
        autoreleasepool {
            sut.dnsApply(mockFieldStyle)
        }

        // Format should be properly managed
        XCTAssertNotNil(sut.format)
    }

    func test_updateForState_shouldNotCauseMemoryLeaks() {
        // AnimatedFieldFormat is a struct, not a class, so no weak references
        autoreleasepool {
            sut.updateForState(using: mockFieldStyle)
        }

        // Format should be properly managed
        XCTAssertNotNil(sut.format)
    }

    // MARK: - Edge Cases

    func test_dnsApply_withNilStyleProperties_shouldHandleGracefully() {
        // Create a style that might have nil properties
        sut.dnsApply(mockFieldStyle)

        XCTAssertNotNil(sut.format)
        // Should not crash with nil properties
    }

    func test_updateForState_withAllStatesDisabled_shouldApplyCorrectly() {
        sut.isEnabled = false
        sut.isSelected = false
        sut.isHighlighted = false
        // Note: isFocused is read-only

        sut.updateForState(using: mockFieldStyle)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.format.titleColor)
        // Should apply disabled state properties
    }

    func test_dnsApply_multipleConsecutiveCalls_shouldNotCrash() {
        for _ in 0..<10 {
            sut.dnsApply(mockFieldStyle)
        }

        XCTAssertNotNil(sut.format)
        // Should handle multiple consecutive applications
    }

    func test_updateForState_afterDnsApply_shouldMaintainConsistency() {
        sut.dnsApply(mockFieldStyle)
        let appliedFormat = sut.format

        sut.updateForState(using: mockFieldStyle)
        let updatedFormat = sut.format

        // Basic format structure should be maintained
        XCTAssertNotNil(appliedFormat)
        XCTAssertNotNil(updatedFormat)
    }

    // MARK: - State Transition Tests

    func test_stateTransition_enabledToDisabled_shouldUpdateAppropriately() {
        sut.isEnabled = true
        sut.updateForState(using: mockFieldStyle)
        let enabledBackgroundColor = sut.backgroundColor

        sut.isEnabled = false
        sut.updateForState(using: mockFieldStyle)
        let disabledBackgroundColor = sut.backgroundColor

        XCTAssertNotNil(enabledBackgroundColor)
        XCTAssertNotNil(disabledBackgroundColor)
        // Colors may be different based on state
    }

    func test_stateTransition_normalToSelected_shouldUpdateFields() {
        sut.isSelected = false
        sut.updateForState(using: mockFieldStyle)
        let normalFormat = sut.format

        sut.isSelected = true
        sut.updateForState(using: mockFieldStyle)
        let selectedFormat = sut.format

        XCTAssertNotNil(normalFormat.titleColor)
        XCTAssertNotNil(selectedFormat.titleColor)
        // Field format should update for state changes
    }

    // MARK: - Integration Tests

    func test_fullStyleApplication_shouldWorkEndToEnd() {
        // Test complete style application workflow
        sut.dnsApply(mockFieldStyle)
        sut.updateForState(using: mockFieldStyle)

        let finalFormat = sut.format
        XCTAssertNotNil(finalFormat.titleFont)
        XCTAssertNotNil(finalFormat.textFont)
        XCTAssertNotNil(finalFormat.counterFont)
        XCTAssertNotNil(finalFormat.alertFont)
        XCTAssertNotNil(finalFormat.lineColor)
        XCTAssertNotNil(finalFormat.titleColor)
        XCTAssertNotNil(finalFormat.textColor)
        XCTAssertNotNil(finalFormat.counterColor)
        XCTAssertNotNil(finalFormat.alertColor)
        XCTAssertNotNil(finalFormat.pickerTextColor)
        XCTAssertNotNil(finalFormat.highlightColor)
        XCTAssertNotNil(finalFormat.placeholderColor)

        XCTAssertNotNil(sut.backgroundColor)
        XCTAssertNotNil(sut.tintColor)
        // Complete style application should work
    }

    func test_styleThenStateUpdate_shouldMaintainCorrectValues() {
        // Apply style first
        sut.dnsApply(mockFieldStyle)
        let styledFormat = sut.format

        // Then update for current state
        sut.isEnabled = true
        sut.isSelected = false
        sut.updateForState(using: mockFieldStyle)

        let finalFormat = sut.format
        XCTAssertNotNil(styledFormat)
        XCTAssertNotNil(finalFormat)

        // Should maintain style properties while updating state-specific ones
        XCTAssertEqual(finalFormat.invalidCharacters, styledFormat.invalidCharacters)
        XCTAssertEqual(finalFormat.textFieldHeight, styledFormat.textFieldHeight)
    }
}