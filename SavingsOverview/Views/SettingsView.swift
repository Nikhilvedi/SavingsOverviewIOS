//
//  SettingsView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccountEntity.createdAt, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<SavingsAccountEntity>
    
    @State private var showingExportAlert = false
    
    var body: some View {
        List {
            // App Info Section
            Section(header: Text("About")) {
                HStack {
                    Text("App Name")
                    Spacer()
                    Text("Savings Overview")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Accounts")
                    Spacer()
                    Text("\(accounts.count)")
                        .foregroundColor(.secondary)
                }
            }
            
            // Data Management Section
            Section(header: Text("Data")) {
                Button(action: { showingExportAlert = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Data")
                    }
                }
                
                NavigationLink(destination: DataManagementView()) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Manage Data")
                    }
                }
            }
            
            // Features Section
            Section(header: Text("Features")) {
                NavigationLink(destination: Text("Coming Soon")) {
                    HStack {
                        Image(systemName: "chart.bar.doc.horizontal")
                        Text("Reports")
                    }
                }
                
                NavigationLink(destination: Text("Coming Soon")) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
                }
            }
            
            // Support Section
            Section(header: Text("Support")) {
                Link(destination: URL(string: "https://github.com")!) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("Help & Support")
                    }
                }
                
                Link(destination: URL(string: "https://github.com")!) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Privacy Policy")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .alert("Export Data", isPresented: $showingExportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Data export feature is coming soon. Your data is stored locally on your device.")
        }
    }
}

// MARK: - Data Management View
struct DataManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccountEntity.createdAt, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<SavingsAccountEntity>
    
    @State private var showingDeleteAllAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Statistics")) {
                HStack {
                    Text("Total Accounts")
                    Spacer()
                    Text("\(accounts.count)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Balance")
                    Spacer()
                    Text(totalBalance.asCurrency())
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Monthly Contribution")
                    Spacer()
                    Text(totalMonthlyContribution.asCurrency())
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Danger Zone")) {
                Button(role: .destructive) {
                    showingDeleteAllAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete All Accounts")
                    }
                }
                .disabled(accounts.isEmpty)
            }
        }
        .navigationTitle("Manage Data")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete All Accounts", isPresented: $showingDeleteAllAlert) {
            Button("Delete All", role: .destructive) {
                deleteAllAccounts()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all accounts? This action cannot be undone.")
        }
    }
    
    private var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    private var totalMonthlyContribution: Double {
        accounts.reduce(0) { $0 + $1.monthlyContribution }
    }
    
    private func deleteAllAccounts() {
        for account in accounts {
            viewContext.delete(account)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete all accounts: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        SettingsView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
