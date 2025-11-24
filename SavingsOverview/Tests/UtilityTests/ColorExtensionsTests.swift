//
//  ColorExtensionsTests.swift
//  SavingsOverviewTests
//
//  Created on 2025
//

import XCTest
import SwiftUI
@testable import SavingsOverview

final class ColorExtensionsTests: XCTestCase {
    
    func testColorFromValidHex() {
        // Given
        let hexString = "#FF6B6B"
        
        // When
        let color = Color(hex: hexString)
        
        // Then
        XCTAssertNotNil(color)
    }
    
    func testColorFromHexWithoutHash() {
        // Given
        let hexString = "FF6B6B"
        
        // When
        let color = Color(hex: hexString)
        
        // Then
        XCTAssertNotNil(color)
    }
    
    func testColorToHex() {
        // Given
        let color = Color(red: 1.0, green: 0.0, blue: 0.0)
        
        // When
        let hex = color.toHex()
        
        // Then
        XCTAssertNotNil(hex)
        XCTAssertTrue(hex?.hasPrefix("#") ?? false)
        XCTAssertEqual(hex?.count, 7) // #RRGGBB
    }
    
    func testColorRoundTrip() {
        // Given
        let originalHex = "#4ECDC4"
        
        // When
        let color = Color(hex: originalHex)
        let convertedHex = color.toHex()
        
        // Then
        XCTAssertNotNil(convertedHex)
        XCTAssertEqual(convertedHex?.uppercased(), originalHex.uppercased())
    }
    
    func testAccountColorsPalette() {
        // Then
        XCTAssertEqual(Color.accountColors.count, 10)
        XCTAssertFalse(Color.accountColors.isEmpty)
    }
    
    func testRandomAccountColor() {
        // When
        let color1 = Color.randomAccountColor()
        let color2 = Color.randomAccountColor()
        
        // Then
        XCTAssertNotNil(color1)
        XCTAssertNotNil(color2)
        // Note: colors might be the same randomly, so we just test they exist
    }
}
