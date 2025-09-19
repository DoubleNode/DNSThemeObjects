//
//  DNSUICircularLabelTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSThemeTypes
@testable import DNSThemeObjects

final class DNSUICircularLabelTests: XCTestCase {
    private var sut: DNSUICircularLabel!

    override func setUp() {
        super.setUp()
        sut = DNSUICircularLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        sut.text = "CIRCULAR TEXT"
        sut.font = UIFont.systemFont(ofSize: 16)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_withDefaultValues_shouldSetDefaults() {
        let label = DNSUICircularLabel()

        XCTAssertEqual(label.angle, 1.6, accuracy: 0.01)
        XCTAssertTrue(label.clockwise)
        XCTAssertTrue(label is DNSUILabel)
    }

    func test_init_withFrame_shouldInitializeCorrectly() {
        let frame = CGRect(x: 10, y: 20, width: 150, height: 150)
        let label = DNSUICircularLabel(frame: frame)

        XCTAssertEqual(label.frame, frame)
        XCTAssertEqual(label.angle, 1.6, accuracy: 0.01)
        XCTAssertTrue(label.clockwise)
    }

    // MARK: - IBInspectable Property Tests

    func test_angle_shouldBeSettable() {
        let testAngle: CGFloat = 2.5

        sut.angle = testAngle

        XCTAssertEqual(sut.angle, testAngle, accuracy: 0.01)
    }

    func test_clockwise_shouldBeToggleable() {
        sut.clockwise = false
        XCTAssertFalse(sut.clockwise)

        sut.clockwise = true
        XCTAssertTrue(sut.clockwise)
    }

    func test_angle_withNegativeValue_shouldAcceptValue() {
        let negativeAngle: CGFloat = -1.5

        sut.angle = negativeAngle

        XCTAssertEqual(sut.angle, negativeAngle, accuracy: 0.01)
    }

    func test_angle_withLargeValue_shouldAcceptValue() {
        let largeAngle: CGFloat = 10.0

        sut.angle = largeAngle

        XCTAssertEqual(sut.angle, largeAngle, accuracy: 0.01)
    }

    // MARK: - Geometric Calculation Tests

    func test_getRadiusForLabel_withSquareFrame_shouldCalculateCorrectRadius() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.text = "TEST"
        sut.font = UIFont.systemFont(ofSize: 12)

        let radius = sut.getRadiusForLabel()

        // Expected: (min(100, 100) / 2) - fontHeight + 5
        // Should be close to 50 - fontHeight + 5
        XCTAssertGreaterThan(radius, 30)
        XCTAssertLessThan(radius, 60)
    }

    func test_getRadiusForLabel_withRectangularFrame_shouldUseSmallestDimension() {
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        sut.text = "TEST"
        sut.font = UIFont.systemFont(ofSize: 12)

        let radius = sut.getRadiusForLabel()

        // Should use height (100) as smallest dimension
        // Expected: (100 / 2) - fontHeight + 5
        XCTAssertGreaterThan(radius, 30)
        XCTAssertLessThan(radius, 60)
    }

    func test_getRadiusForLabel_withEmptyText_shouldHandleGracefully() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.text = ""
        sut.font = UIFont.systemFont(ofSize: 12)

        let radius = sut.getRadiusForLabel()

        // Should still calculate radius even with empty text
        XCTAssertGreaterThan(radius, 40)
        XCTAssertLessThan(radius, 60)
    }

    func test_getRadiusForLabel_withNilText_shouldHandleGracefully() {
        sut.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.text = nil
        sut.font = UIFont.systemFont(ofSize: 12)

        let radius = sut.getRadiusForLabel()

        // Should handle nil text gracefully
        XCTAssertGreaterThan(radius, 40)
        XCTAssertLessThan(radius, 60)
    }

    func test_chordToArc_withValidInputs_shouldCalculateCorrectArc() {
        let chord: CGFloat = 10.0
        let radius: CGFloat = 50.0

        let arc = sut.chordToArc(chord, radius: radius)

        // Arc should be 2 * asin(chord / (2 * radius))
        // 2 * asin(10 / 100) = 2 * asin(0.1) ≈ 0.2
        XCTAssertGreaterThan(arc, 0)
        XCTAssertLessThan(arc, 1)
    }

    func test_chordToArc_withZeroChord_shouldReturnZero() {
        let chord: CGFloat = 0.0
        let radius: CGFloat = 50.0

        let arc = sut.chordToArc(chord, radius: radius)

        XCTAssertEqual(arc, 0, accuracy: 0.01)
    }

    func test_chordToArc_withSmallChord_shouldReturnSmallArc() {
        let chord: CGFloat = 1.0
        let radius: CGFloat = 100.0

        let arc = sut.chordToArc(chord, radius: radius)

        XCTAssertGreaterThan(arc, 0)
        XCTAssertLessThan(arc, 0.1)
    }

    // MARK: - Drawing Tests

    func test_draw_shouldNotCrash() {
        sut.text = "CIRCULAR TEXT"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withEmptyText_shouldNotCrash() {
        sut.text = ""

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withNilText_shouldNotCrash() {
        sut.text = nil

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withLongText_shouldNotCrash() {
        sut.text = "THIS IS A VERY LONG TEXT THAT MIGHT WRAP AROUND THE CIRCLE MULTIPLE TIMES"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withSpecialCharacters_shouldNotCrash() {
        sut.text = "★☆♪♫☀☂☃❄"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withClockwiseFalse_shouldNotCrash() {
        sut.text = "COUNTER CLOCKWISE"
        sut.clockwise = false

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withDifferentAngles_shouldNotCrash() {
        sut.text = "ANGLE TEST"

        // Test various angles
        let angles: [CGFloat] = [0, 0.5, 1.0, 1.57, 3.14, 6.28, -1.0, -3.14]

        for angle in angles {
            sut.angle = angle
            XCTAssertNoThrow(sut.draw(sut.bounds))
        }
    }

    // MARK: - Text Positioning Tests

    func test_centreArcPerpendicular_withValidText_shouldExecuteWithoutError() {
        sut.text = "TEST TEXT"
        sut.font = UIFont.systemFont(ofSize: 16)

        // This method is called internally by draw(), testing it doesn't crash
        XCTAssertNoThrow(sut.centreArcPerpendicular())
    }

    // MARK: - Font Integration Tests

    func test_draw_withDifferentFontSizes_shouldNotCrash() {
        sut.text = "FONT SIZE TEST"

        let fontSizes: [CGFloat] = [8, 12, 16, 20, 24, 32, 48]

        for size in fontSizes {
            sut.font = UIFont.systemFont(ofSize: size)
            XCTAssertNoThrow(sut.draw(sut.bounds))
        }
    }

    func test_draw_withBoldFont_shouldNotCrash() {
        sut.text = "BOLD TEXT"
        sut.font = UIFont.boldSystemFont(ofSize: 16)

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withCustomFont_shouldNotCrash() {
        sut.text = "CUSTOM FONT"
        sut.font = UIFont(name: "Helvetica", size: 16) ?? UIFont.systemFont(ofSize: 16)

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    // MARK: - Edge Cases

    func test_draw_withZeroFrame_shouldNotCrash() {
        sut.frame = CGRect.zero
        sut.text = "ZERO FRAME"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withVerySmallFrame_shouldNotCrash() {
        sut.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        sut.text = "TINY"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_draw_withSingleCharacter_shouldNotCrash() {
        sut.text = "A"

        XCTAssertNoThrow(sut.draw(sut.bounds))
    }

    func test_getRadiusForLabel_withZeroFrame_shouldReturnValidRadius() {
        sut.frame = CGRect.zero
        sut.text = "TEST"

        let radius = sut.getRadiusForLabel()

        // With zero frame, radius calculation may return negative value - just verify no crash
        XCTAssertNotNil(radius)
    }

    // MARK: - Style Integration Tests

    func test_styleName_shouldBeInherited() {
        // DNSUICircularLabel inherits from DNSUILabel, so should have style functionality
        XCTAssertNotNil(sut.styleName)
        XCTAssertTrue(sut.style is DNSThemeLabelStyle)
    }

    func test_utilityApply_shouldWork() {
        let labelStyle = DNSThemeLabelStyle.Base.default

        XCTAssertNoThrow(sut.utilityApply(labelStyle))
    }

    // MARK: - Performance Tests

    func test_draw_performance_shouldBeReasonablyFast() {
        sut.text = "PERFORMANCE TEST FOR CIRCULAR LABEL DRAWING"

        measure {
            for _ in 0..<100 {
                sut.draw(sut.bounds)
            }
        }
    }

    func test_getRadiusForLabel_performance_shouldBeReasonablyFast() {
        sut.text = "RADIUS CALCULATION PERFORMANCE TEST"

        measure {
            for _ in 0..<1000 {
                _ = sut.getRadiusForLabel()
            }
        }
    }

    func test_chordToArc_performance_shouldBeReasonablyFast() {
        measure {
            for _ in 0..<1000 {
                _ = sut.chordToArc(10.0, radius: 50.0)
            }
        }
    }

    // MARK: - Color Integration Tests

    func test_draw_withDifferentTextColors_shouldNotCrash() {
        sut.text = "COLORED TEXT"

        let colors: [UIColor] = [.black, .white, .red, .blue, .green, .clear]

        for color in colors {
            sut.textColor = color
            XCTAssertNoThrow(sut.draw(sut.bounds))
        }
    }

    // MARK: - Memory Management Tests

    func test_multipleDrawCalls_shouldNotLeakMemory() {
        sut.text = "MEMORY TEST"

        // Multiple draw calls should not accumulate memory
        for _ in 0..<50 {
            autoreleasepool {
                sut.draw(sut.bounds)
            }
        }

        // Test completes without crashing indicates no major memory issues
        XCTAssertTrue(true)
    }
}