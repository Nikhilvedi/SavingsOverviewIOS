//
//  CurrencyFormatterTests.swift
//  SavingsOverviewTests
//
//  Created on 2025
//

import XCTest
@testable import SavingsOverview

final class CurrencyFormatterTests: XCTestCase {
    
    func testDoubleAsCurrency() {
        // Given
        let amount = 1234.56
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("1,234.56") || formatted.contains("1234.56"))
        XCTAssertTrue(formatted.contains("$"))
    }
    
    func testZeroAsCurrency() {
        // Given
        let amount = 0.0
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("0.00"))
        XCTAssertTrue(formatted.contains("$"))
    }
    
    func testNegativeAsCurrency() {
        // Given
        let amount = -100.0
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("100"))
        XCTAssertTrue(formatted.contains("$") || formatted.contains("-"))
    }
    
    func testLargeAmountAsCurrency() {
        // Given
        let amount = 1_000_000.0
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("1,000,000") || formatted.contains("1000000"))
        XCTAssertTrue(formatted.contains("$"))
    }
    
    func testIntAsCurrency() {
        // Given
        let amount = 1234
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("1,234") || formatted.contains("1234"))
        XCTAssertTrue(formatted.contains("$"))
    }
    
    func testDecimalPrecision() {
        // Given
        let amount = 10.5
        
        // When
        let formatted = amount.asCurrency()
        
        // Then
        XCTAssertTrue(formatted.contains("10.50"))
    }
}
