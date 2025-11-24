//
//  DashboardViewModel.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation
import CoreData
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var accounts: [SavingsAccount] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showingAddAccount = false
    
    private let repository: SavingsRepository
    
    init(repository: SavingsRepository) {
        self.repository = repository
    }
    
    // MARK: - Computed Properties
    
    var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var totalMonthlyContribution: Double {
        accounts.reduce(0) { $0 + $1.monthlyContribution }
    }
    
    var accountCount: Int {
        accounts.count
    }
    
    var sortedAccounts: [SavingsAccount] {
        accounts.sorted { $0.balance > $1.balance }
    }
    
    var hasAccounts: Bool {
        !accounts.isEmpty
    }
    
    // MARK: - Chart Data
    
    var chartData: [(name: String, balance: Double, color: String)] {
        accounts.map { account in
            (name: account.name, balance: account.balance, color: account.colorHex)
        }
    }
    
    // MARK: - Methods
    
    func loadAccounts() {
        isLoading = true
        error = nil
        
        do {
            accounts = try repository.fetchAll()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func deleteAccount(_ account: SavingsAccount) {
        do {
            try repository.delete(account)
            loadAccounts()
        } catch {
            self.error = error
        }
    }
    
    func projectedTotal(months: Int) -> Double {
        accounts.reduce(0) { total, account in
            total + account.projectedBalance(months: months)
        }
    }
}
