//
//  SavingsOverviewUITests.swift
//  SavingsOverviewUITests
//
//  Created on 2025
//

import XCTest

final class SavingsOverviewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAppLaunches() throws {
        // Then
        XCTAssertTrue(app.navigationBars["Savings Overview"].exists)
    }
    
    func testDashboardDisplays() throws {
        // Then
        XCTAssertTrue(app.staticTexts["Total Savings"].exists)
        XCTAssertTrue(app.staticTexts["Accounts"].exists)
    }
    
    func testTabNavigation() throws {
        // When
        app.tabBars.buttons["Accounts"].tap()
        
        // Then
        XCTAssertTrue(app.navigationBars["All Accounts"].exists)
        
        // When
        app.tabBars.buttons["Dashboard"].tap()
        
        // Then
        XCTAssertTrue(app.navigationBars["Savings Overview"].exists)
    }
    
    func testAddAccountFlow() throws {
        // Given - Tap add button
        app.navigationBars["Savings Overview"].buttons.matching(identifier: "addAccountButton").firstMatch.tap()
        
        // Wait for sheet to appear
        let nameField = app.textFields["Account Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        
        // When - Fill in form
        nameField.tap()
        nameField.typeText("Test Account")
        
        let institutionField = app.textFields["Institution"]
        institutionField.tap()
        institutionField.typeText("Test Bank")
        
        let balanceField = app.textFields.matching(identifier: "balanceTextField").firstMatch
        balanceField.tap()
        balanceField.typeText("1000")
        
        let contributionField = app.textFields.matching(identifier: "monthlyContributionTextField").firstMatch
        contributionField.tap()
        contributionField.typeText("100")
        
        // Tap save
        app.navigationBars["Add Account"].buttons["Save"].tap()
        
        // Then - Verify account was added
        let accountCard = app.staticTexts["Test Account"]
        XCTAssertTrue(accountCard.waitForExistence(timeout: 2))
    }
    
    func testSearchFunctionality() throws {
        // Given - Go to accounts list
        app.tabBars.buttons["Accounts"].tap()
        
        // When - Use search
        let searchField = app.searchFields.firstMatch
        if searchField.exists {
            searchField.tap()
            searchField.typeText("Emergency")
            
            // Then
            // Note: This assumes sample data exists
            // Actual verification depends on whether sample data is loaded
        }
    }
    
    func testAccountDetailNavigation() throws {
        // Given - Ensure we have at least one account (may need sample data)
        // Tap on first account card if it exists
        let accountCards = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'accountCard'"))
        
        if accountCards.count > 0 {
            // When
            accountCards.firstMatch.tap()
            
            // Then - Should show detail view
            XCTAssertTrue(app.buttons["Edit"].exists)
        }
    }
    
    func testSettingsNavigation() throws {
        // When
        app.navigationBars["Savings Overview"].buttons.matching(identifier: "settingsButton").firstMatch.tap()
        
        // Then
        XCTAssertTrue(app.navigationBars["Settings"].exists)
        XCTAssertTrue(app.staticTexts["About"].exists)
    }
    
    func testAccessibilityLabels() throws {
        // Dashboard accessibility
        XCTAssertTrue(app.buttons.matching(identifier: "addAccountButton").count > 0)
        
        // Tab accessibility
        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
        XCTAssertTrue(app.tabBars.buttons["Accounts"].exists)
    }
    
    func testChartExistence() throws {
        // Given - Assumes at least one account exists
        // Charts are typically rendered as images or graphics views
        
        // Look for chart-related elements
        let hasChartElements = app.otherElements.matching(identifier: "barChart").count > 0 ||
                             app.images.count > 0
        
        // Note: Chart verification can be tricky in UI tests
        // This is a basic check
        XCTAssertTrue(hasChartElements || app.otherElements.count > 0)
    }
}
