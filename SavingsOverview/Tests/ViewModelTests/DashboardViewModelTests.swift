//
//  DashboardViewModelTests.swift
//  SavingsOverviewTests
//
//  Created on 2025
//

import XCTest
import CoreData
@testable import SavingsOverview

@MainActor
final class DashboardViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var repository: SavingsRepository!
    var viewModel: DashboardViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        repository = SavingsRepository(context: persistenceController.container.viewContext)
        viewModel = DashboardViewModel(repository: repository)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        repository = nil
        persistenceController = nil
        try await super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.accounts.count, 0)
        XCTAssertEqual(viewModel.totalBalance, 0.0)
        XCTAssertEqual(viewModel.totalMonthlyContribution, 0.0)
        XCTAssertFalse(viewModel.hasAccounts)
    }
    
    func testLoadAccounts() throws {
        // Given
        let account = SavingsAccount(
            name: "Test Account",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        try repository.create(account)
        
        // When
        viewModel.loadAccounts()
        
        // Then
        XCTAssertEqual(viewModel.accounts.count, 1)
        XCTAssertTrue(viewModel.hasAccounts)
    }
    
    func testTotalBalance() throws {
        // Given
        let account1 = SavingsAccount(
            name: "Account 1",
            institution: "Bank 1",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        let account2 = SavingsAccount(
            name: "Account 2",
            institution: "Bank 2",
            balance: 2000.0,
            monthlyContribution: 200.0,
            colorHex: "#4ECDC4"
        )
        try repository.create(account1)
        try repository.create(account2)
        
        // When
        viewModel.loadAccounts()
        
        // Then
        XCTAssertEqual(viewModel.totalBalance, 3000.0)
    }
    
    func testTotalMonthlyContribution() throws {
        // Given
        let account1 = SavingsAccount(
            name: "Account 1",
            institution: "Bank 1",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        let account2 = SavingsAccount(
            name: "Account 2",
            institution: "Bank 2",
            balance: 2000.0,
            monthlyContribution: 250.0,
            colorHex: "#4ECDC4"
        )
        try repository.create(account1)
        try repository.create(account2)
        
        // When
        viewModel.loadAccounts()
        
        // Then
        XCTAssertEqual(viewModel.totalMonthlyContribution, 350.0)
    }
    
    func testSortedAccounts() throws {
        // Given
        let account1 = SavingsAccount(
            name: "Account 1",
            institution: "Bank 1",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        let account2 = SavingsAccount(
            name: "Account 2",
            institution: "Bank 2",
            balance: 3000.0,
            monthlyContribution: 200.0,
            colorHex: "#4ECDC4"
        )
        let account3 = SavingsAccount(
            name: "Account 3",
            institution: "Bank 3",
            balance: 2000.0,
            monthlyContribution: 150.0,
            colorHex: "#95E1D3"
        )
        try repository.create(account1)
        try repository.create(account2)
        try repository.create(account3)
        
        // When
        viewModel.loadAccounts()
        let sorted = viewModel.sortedAccounts
        
        // Then
        XCTAssertEqual(sorted.count, 3)
        XCTAssertEqual(sorted[0].balance, 3000.0) // Highest balance first
        XCTAssertEqual(sorted[1].balance, 2000.0)
        XCTAssertEqual(sorted[2].balance, 1000.0)
    }
    
    func testProjectedTotal() throws {
        // Given
        let account1 = SavingsAccount(
            name: "Account 1",
            institution: "Bank 1",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        let account2 = SavingsAccount(
            name: "Account 2",
            institution: "Bank 2",
            balance: 2000.0,
            monthlyContribution: 200.0,
            colorHex: "#4ECDC4"
        )
        try repository.create(account1)
        try repository.create(account2)
        
        // When
        viewModel.loadAccounts()
        let projected = viewModel.projectedTotal(months: 12)
        
        // Then
        // (1000 + 100*12) + (2000 + 200*12) = 2200 + 4400 = 6600
        XCTAssertEqual(projected, 6600.0)
    }
    
    func testDeleteAccount() throws {
        // Given
        let account = SavingsAccount(
            name: "Test Account",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        try repository.create(account)
        viewModel.loadAccounts()
        XCTAssertEqual(viewModel.accounts.count, 1)
        
        // When
        viewModel.deleteAccount(account)
        
        // Then
        XCTAssertEqual(viewModel.accounts.count, 0)
    }
}
