//
//  AccountManagementUITests.swift
//  SavingsOverviewUITests
//
//  Created on 2025
//

import XCTest

final class AccountManagementUITests: XCTestCase {
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
    
    func testCreateAndDeleteAccount() throws {
        // Create account
        app.navigationBars["Savings Overview"].buttons.matching(identifier: "addAccountButton").firstMatch.tap()
        
        let nameField = app.textFields["Account Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        
        nameField.tap()
        nameField.typeText("Temporary Account")
        
        let institutionField = app.textFields["Institution"]
        institutionField.tap()
        institutionField.typeText("Temp Bank")
        
        let balanceField = app.textFields.matching(identifier: "balanceTextField").firstMatch
        balanceField.tap()
        balanceField.typeText("500")
        
        let contributionField = app.textFields.matching(identifier: "monthlyContributionTextField").firstMatch
        contributionField.tap()
        contributionField.typeText("50")
        
        app.navigationBars["Add Account"].buttons["Save"].tap()
        
        // Verify created
        let accountText = app.staticTexts["Temporary Account"]
        XCTAssertTrue(accountText.waitForExistence(timeout: 2))
        
        // Navigate to edit
        let accountCard = app.buttons.matching(identifier: "accountCard_Temporary Account").firstMatch
        if accountCard.exists {
            accountCard.tap()
            
            // Tap edit
            app.buttons["Edit"].tap()
            
            // Scroll to delete button if needed
            if app.buttons["Delete Account"].exists {
                app.buttons["Delete Account"].tap()
                
                // Confirm deletion
                app.buttons["Delete"].tap()
                
                // Verify deleted (back on dashboard or list)
                XCTAssertFalse(app.staticTexts["Temporary Account"].exists)
            }
        }
    }
    
    func testEditAccount() throws {
        // Given - Create an account first
        app.navigationBars["Savings Overview"].buttons.matching(identifier: "addAccountButton").firstMatch.tap()
        
        let nameField = app.textFields["Account Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        
        nameField.tap()
        nameField.typeText("Edit Test")
        
        let institutionField = app.textFields["Institution"]
        institutionField.tap()
        institutionField.typeText("Edit Bank")
        
        let balanceField = app.textFields.matching(identifier: "balanceTextField").firstMatch
        balanceField.tap()
        balanceField.typeText("1000")
        
        let contributionField = app.textFields.matching(identifier: "monthlyContributionTextField").firstMatch
        contributionField.tap()
        contributionField.typeText("100")
        
        app.navigationBars["Add Account"].buttons["Save"].tap()
        
        // Navigate to detail and edit
        let accountCard = app.buttons.matching(identifier: "accountCard_Edit Test").firstMatch
        if accountCard.waitForExistence(timeout: 2) {
            accountCard.tap()
            
            // When - Edit the account
            app.buttons["Edit"].tap()
            
            let editNameField = app.textFields["Account Name"]
            if editNameField.exists {
                editNameField.tap()
                editNameField.clearText()
                editNameField.typeText("Edited Name")
                
                app.buttons["Save"].tap()
                
                // Then - Verify changes
                XCTAssertTrue(app.staticTexts["Edited Name"].waitForExistence(timeout: 2))
            }
        }
    }
    
    func testFormValidation() throws {
        // Given
        app.navigationBars["Savings Overview"].buttons.matching(identifier: "addAccountButton").firstMatch.tap()
        
        // When - Try to save without filling fields
        let saveButton = app.navigationBars["Add Account"].buttons["Save"]
        
        // Then - Save button should be disabled
        XCTAssertFalse(saveButton.isEnabled)
        
        // When - Fill only name
        let nameField = app.textFields["Account Name"]
        nameField.tap()
        nameField.typeText("Test")
        
        // Then - Still disabled
        XCTAssertFalse(saveButton.isEnabled)
    }
}

// MARK: - Helper Extensions
extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
