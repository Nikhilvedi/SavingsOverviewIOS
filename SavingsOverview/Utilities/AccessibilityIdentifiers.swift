//
//  AccessibilityIdentifiers.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation

/// Centralized accessibility identifiers for UI testing
enum AccessibilityIdentifiers {
    // Dashboard
    static let addAccountButton = "addAccountButton"
    static let settingsButton = "settingsButton"
    static let totalBalanceLabel = "totalBalanceLabel"
    static let barChart = "barChart"
    
    // Account Cards
    static func accountCard(name: String) -> String {
        return "accountCard_\(name)"
    }
    
    // Forms
    static let accountNameTextField = "accountNameTextField"
    static let institutionTextField = "institutionTextField"
    static let balanceTextField = "balanceTextField"
    static let monthlyContributionTextField = "monthlyContributionTextField"
    static let saveButton = "saveButton"
    static let cancelButton = "cancelButton"
    static let deleteButton = "deleteButton"
    
    // Tabs
    static let dashboardTab = "dashboardTab"
    static let accountsTab = "accountsTab"
    
    // Account Detail
    static let editButton = "editButton"
    static let projectionChart = "projectionChart"
    
    // Search
    static let searchField = "searchField"
}
