// SavingsOverview/Tests/RepositoryTests/SavingsRepositoryTests.swift
//  SavingsRepositoryTests
//  SavingsOverviewTests
//
//  Created on 2025
//

#if canImport(XCTest)
import XCTest
import CoreData
@testable import SavingsOverview

final class SavingsRepositoryTests: XCTestCase {
    var persistenceController: PersistenceController!
    var repository: SavingsRepository!

    override func setUp() {
        super.setUp()
        // Use in-memory store for testing
        persistenceController = PersistenceController(inMemory: true)
        repository = SavingsRepository(context: persistenceController.container.viewContext)
    }

    override func tearDown() {
        repository = nil
        persistenceController = nil
        super.tearDown()
    }

    func testCreateAccount() throws {
        // Given
        let account = SavingsAccount(
            name: "Test Account",
            institution: "Test Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )

        // When
        try repository.create(account)
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 1)
        XCTAssertEqual(accounts.first?.name, "Test Account")
        XCTAssertEqual(accounts.first?.institution, "Test Bank")
        XCTAssertEqual(accounts.first?.balance, 1000.0)
    }

    func testFetchAllAccounts() throws {
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

        // When
        try repository.create(account1)
        try repository.create(account2)
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 2)
    }

    func testUpdateAccount() throws {
        // Given
        var account = SavingsAccount(
            name: "Original Name",
            institution: "Original Bank",
            balance: 1000.0,
            monthlyContribution: 100.0,
            colorHex: "#FF6B6B"
        )
        try repository.create(account)

        // When
        account.name = "Updated Name"
        account.balance = 2000.0
        try repository.update(account)
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 1)
        XCTAssertEqual(accounts.first?.name, "Updated Name")
        XCTAssertEqual(accounts.first?.balance, 2000.0)
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

        // When
        try repository.delete(account)
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 0)
    }

    func testFetchAllEmptyDatabase() throws {
        // When
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 0)
    }

    func testMultipleOperations() throws {
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

        // When
        try repository.create(account1)
        try repository.create(account2)
        try repository.delete(account1)
        let accounts = try repository.fetchAll()

        // Then
        XCTAssertEqual(accounts.count, 1)
        XCTAssertEqual(accounts.first?.name, "Account 2")
    }
}
#endif
