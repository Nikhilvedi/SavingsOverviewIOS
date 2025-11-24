//
//  AccountListViewModel.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation
import Combine

@MainActor
class AccountListViewModel: ObservableObject {
    @Published var accounts: [SavingsAccount] = []
    @Published var searchText = ""
    @Published var sortOption: SortOption = .name
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: SavingsRepository
    
    init(repository: SavingsRepository) {
        self.repository = repository
    }
    
    enum SortOption {
        case name
        case balance
        case institution
        case date
    }
    
    // MARK: - Computed Properties
    
    var filteredAndSortedAccounts: [SavingsAccount] {
        let filtered = filterAccounts(accounts, searchText: searchText)
        return sortAccounts(filtered, by: sortOption)
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
    
    private func filterAccounts(_ accounts: [SavingsAccount], searchText: String) -> [SavingsAccount] {
        guard !searchText.isEmpty else { return accounts }
        
        return accounts.filter { account in
            account.name.localizedCaseInsensitiveContains(searchText) ||
            account.institution.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func sortAccounts(_ accounts: [SavingsAccount], by option: SortOption) -> [SavingsAccount] {
        switch option {
        case .name:
            return accounts.sorted { $0.name < $1.name }
        case .balance:
            return accounts.sorted { $0.balance > $1.balance }
        case .institution:
            return accounts.sorted { $0.institution < $1.institution }
        case .date:
            return accounts.sorted { $0.createdAt > $1.createdAt }
        }
    }
}
