//
//  AccountDetailViewModelTests.swift
//  SavingsOverviewTests
//
//  Created on 2025
//

import XCTest
@testable import SavingsOverview

@MainActor
final class AccountDetailViewModelTests: XCTestCase {
    var viewModel: AccountDetailViewModel!
    var testAccount: SavingsAccount!
    
    override func setUp() async throws {
        try await super.setUp()
        testAccount = SavingsAccount(
            name: "Test Account",
            institution: "Test Bank",
            balance: 5000.0,
            monthlyContribution: 500.0,
            colorHex: "#FF6B6B",
            createdAt: Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        )
        viewModel = AccountDetailViewModel(account: testAccount)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        testAccount = nil
        try await super.tearDown()
    }
    
    func testInitialization() {
        // Then
        XCTAssertEqual(viewModel.currentBalance, 5000.0)
        XCTAssertEqual(viewModel.monthlyContribution, 500.0)
        XCTAssertEqual(viewModel.projectionMonths, 12)
    }
    
    func testAnnualGrowth() {
        // Then
        XCTAssertEqual(viewModel.annualGrowth, 6000.0) // 500 * 12
    }
    
    func testProjectedBalance() {
        // Given
        viewModel.projectionMonths = 12
        
        // When
        let projected = viewModel.projectedBalance
        
        // Then
        XCTAssertEqual(projected, 11000.0) // 5000 + (500 * 12)
    }
    
    func testProjectionDataGeneration() {
        // Given
        viewModel.projectionMonths = 6
        
        // When
        let data = viewModel.projectionData()
        
        // Then
        XCTAssertEqual(data.count, 7) // 0 to 6 months inclusive
        XCTAssertEqual(data.first?.balance, 5000.0) // Month 0
        XCTAssertEqual(data.last?.balance, 8000.0) // Month 6: 5000 + (500 * 6)
    }
    
    func testMilestones() {
        // When
        let milestones = viewModel.milestones
        
        // Then
        XCTAssertFalse(milestones.isEmpty)
        XCTAssertTrue(milestones.allSatisfy { $0.target > testAccount.balance })
        
        // Check first milestone
        if let firstMilestone = milestones.first {
            XCTAssertEqual(firstMilestone.target, 10000.0)
            let expectedMonths = Int(ceil((10000.0 - 5000.0) / 500.0))
            XCTAssertEqual(firstMilestone.monthsToReach, expectedMonths)
        }
    }
    
    func testMilestonesProgress() {
        // Given
        let account = SavingsAccount(
            name: "Test",
            institution: "Bank",
            balance: 7500.0,
            monthlyContribution: 500.0,
            colorHex: "#FF6B6B"
        )
        let vm = AccountDetailViewModel(account: account)
        
        // When
        let milestones = vm.milestones
        
        // Then
        if let firstMilestone = milestones.first {
            XCTAssertEqual(firstMilestone.target, 10000.0)
            XCTAssertEqual(firstMilestone.progress, 0.75, accuracy: 0.01) // 7500/10000
        }
    }
    
    func testAccountAge() {
        // Then
        XCTAssertTrue(viewModel.accountAge.contains("month"))
    }
    
    func testCreatedDate() {
        // Then
        XCTAssertFalse(viewModel.createdDate.isEmpty)
    }
}
