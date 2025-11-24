//
//  AccountListView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI
import CoreData

struct AccountListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccountEntity.name, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<SavingsAccountEntity>
    
    @State private var showingAddAccount = false
    @State private var searchText = ""
    
    private var filteredAccounts: [SavingsAccount] {
        let models = accounts.compactMap { SavingsAccount.fromManagedObject($0) }
        
        if searchText.isEmpty {
            return models
        } else {
            return models.filter { account in
                account.name.localizedCaseInsensitiveContains(searchText) ||
                account.institution.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if filteredAccounts.isEmpty {
                    emptyStateView
                } else {
                    ForEach(filteredAccounts) { account in
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            accountRow(account: account)
                        }
                    }
                }
            }
            .navigationTitle("All Accounts")
            .searchable(text: $searchText, prompt: "Search accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAccount = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private func accountRow(account: SavingsAccount) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: account.colorHex))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "banknote")
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.headline)
                
                Text(account.institution)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(account.balance.asCurrency())
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.caption2)
                    Text(account.monthlyContribution.asCurrency())
                        .font(.caption)
                }
                .foregroundColor(Color(hex: account.colorHex))
            }
        }
        .padding(.vertical, 4)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty ? "No Accounts" : "No Results")
                .font(.title3)
                .bold()
            
            Text(searchText.isEmpty ? "Add your first savings account" : "Try a different search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .listRowBackground(Color.clear)
    }
}

// MARK: - Preview
#Preview {
    AccountListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
