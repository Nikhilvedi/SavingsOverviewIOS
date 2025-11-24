//
//  SavingsAccountModelTests.swift
//  SavingsOverviewTests
//
//  Created on 2025
//

import XCTest
@testable import SavingsOverview

final class SavingsAccountModelTests: XCTestCase {
    
    func testAccountInitialization() {
        // Given
        let name = "Test Account"
        let institution = "Test Bank"
        let balance = 1000.0
        let monthlyContribution = 100.0
        let colorHex = "#FF6B6B"
        
        // When
        let account = SavingsAccount(
            name: name,
            institution: institution,
            balance: balance,
            monthlyContribution: monthlyContribution,
            colorHex: colorHex
        )
        
        // Then
        XCTAssertEqual(account.name, name)
        XCTAssertEqual(account.institution, institution)
        XCTAssertEqual(account.balance, balance)
        XCTAssertEqual(account.monthlyContribution, monthlyContribution)
        XCTAssertEqual(account.colorHex, colorHex)
        XCTAssertNotNil(account.id)
        XCTAssertNotNil(account.createdAt)
    }
    
    func testProjectedBalanceZeroMonths() {
        // Given
        let account = SavingsAccount(
            name: "Test",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        
        // When
        let projected = account.projectedBalance(months: 0)
        
        // Then
        XCTAssertEqual(projected, 1000.0)
    }
    
    func testProjectedBalanceOneMonth() {
        // Given
        let account = SavingsAccount(
            name: "Test",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        
        // When
        let projected = account.projectedBalance(months: 1)
        
        // Then
        XCTAssertEqual(projected, 1100.0)
    }
    
    func testProjectedBalanceTwelveMonths() {
        // Given
        let account = SavingsAccount(
            name: "Test",
            institution: "Test Bank",
            balance: 5000.0,
            monthlyContribution: 500.0,
            colorHex: "#FF6B6B"
        )
        
        // When
        let projected = account.projectedBalance(months: 12)
        
        // Then
        XCTAssertEqual(projected, 11000.0)
    }
    
    func testProjectedBalanceWithZeroContribution() {
        // Given
        let account = SavingsAccount(
            name: "Test",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 0.0,
            colorHex: "#FF6B6B"
        )
        
        // When
        let projected = account.projectedBalance(months: 12)
        
        // Then
        XCTAssertEqual(projected, 1000.0)
    }
    
    func testAccountCodable() throws {
        // Given
        let account = SavingsAccount(
            name: "Test Account",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(account)
        let decoder = JSONDecoder()
        let decodedAccount = try decoder.decode(SavingsAccount.self, from: data)
        
        // Then
        XCTAssertEqual(decodedAccount.id, account.id)
        XCTAssertEqual(decodedAccount.name, account.name)
        XCTAssertEqual(decodedAccount.institution, account.institution)
        XCTAssertEqual(decodedAccount.balance, account.balance)
        XCTAssertEqual(decodedAccount.monthlyContribution, account.monthlyContribution)
        XCTAssertEqual(decodedAccount.colorHex, account.colorHex)
    }
    
    func testSampleDataExists() {
        // Then
        XCTAssertEqual(SavingsAccount.samples.count, 3)
        XCTAssertNotNil(SavingsAccount.sample1)
        XCTAssertNotNil(SavingsAccount.sample2)
        XCTAssertNotNil(SavingsAccount.sample3)
    }
}
