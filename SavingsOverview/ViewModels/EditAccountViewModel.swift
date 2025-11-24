//
//  EditAccountViewModel.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation
import SwiftUI

@MainActor
class EditAccountViewModel: ObservableObject {
    @Published var name: String
    @Published var institution: String
    @Published var balanceText: String
    @Published var monthlyContributionText: String
    @Published var selectedColor: Color
    @Published var error: Error?
    @Published var showingError = false
    @Published var showingDeleteConfirmation = false
    
    let account: SavingsAccount
    private let repository: SavingsRepository
    var onSave: (() -> Void)?
    var onDelete: (() -> Void)?
    
    init(account: SavingsAccount, repository: SavingsRepository) {
        self.account = account
        self.repository = repository
        self.name = account.name
        self.institution = account.institution
        self.balanceText = String(format: "%.2f", account.balance)
        self.monthlyContributionText = String(format: "%.2f", account.monthlyContribution)
        self.selectedColor = Color(hex: account.colorHex)
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
    
    var hasChanges: Bool {
        name != account.name ||
        institution != account.institution ||
        balance != account.balance ||
        monthlyContribution != account.monthlyContribution ||
        selectedColor.toHex() != account.colorHex
    }
    
    // MARK: - Actions
    
    func save() {
        guard isValid,
              let balanceValue = balance,
              let contributionValue = monthlyContribution else {
            showingError = true
            return
        }
        
        let updatedAccount = SavingsAccount(
            id: account.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            institution: institution.trimmingCharacters(in: .whitespacesAndNewlines),
            balance: balanceValue,
            monthlyContribution: contributionValue,
            colorHex: selectedColor.toHex() ?? account.colorHex,
            createdAt: account.createdAt
        )
        
        do {
            try repository.update(updatedAccount)
            onSave?()
        } catch {
            self.error = error
            showingError = true
        }
    }
    
    func delete() {
        do {
            try repository.delete(account)
            onDelete?()
        } catch {
            self.error = error
            showingError = true
        }
    }
}
