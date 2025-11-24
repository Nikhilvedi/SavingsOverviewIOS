//
//  AddAccountViewModel.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation
import SwiftUI

@MainActor
class AddAccountViewModel: ObservableObject {
    @Published var name = ""
    @Published var institution = ""
    @Published var balanceText = ""
    @Published var monthlyContributionText = ""
    @Published var selectedColor = Color.accountColors[0]
    @Published var error: Error?
    @Published var showingError = false
    
    private let repository: SavingsRepository
    var onSave: (() -> Void)?
    
    init(repository: SavingsRepository) {
        self.repository = repository
    }
    
    // MARK: - Validation
    
    var isValid: Bool {
        !name.isEmpty &&
        !institution.isEmpty &&
        balance != nil &&
        monthlyContribution != nil
    }
    
    var balance: Double? {
        Double(balanceText)
    }
    
    var monthlyContribution: Double? {
        Double(monthlyContributionText)
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if name.isEmpty {
            errors.append("Account name is required")
        }
        if institution.isEmpty {
            errors.append("Institution is required")
        }
        if balance == nil {
            errors.append("Balance must be a valid number")
        }
        if monthlyContribution == nil {
            errors.append("Monthly contribution must be a valid number")
        }
        
        return errors
    }
    
    // MARK: - Actions
    
    func save() {
        guard isValid,
              let balanceValue = balance,
              let contributionValue = monthlyContribution else {
            showingError = true
            return
        }
        
        let newAccount = SavingsAccount(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            institution: institution.trimmingCharacters(in: .whitespacesAndNewlines),
            balance: balanceValue,
            monthlyContribution: contributionValue,
            colorHex: selectedColor.toHex() ?? "#4ECDC4"
        )
        
        do {
            try repository.create(newAccount)
            onSave?()
        } catch {
            self.error = error
            showingError = true
        }
    }
    
    func reset() {
        name = ""
        institution = ""
        balanceText = ""
        monthlyContributionText = ""
        selectedColor = Color.accountColors[0]
        error = nil
        showingError = false
    }
}
