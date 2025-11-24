//
//  DashboardView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI
import CoreData
import Charts

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccountEntity.createdAt, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<SavingsAccountEntity>
    
    @State private var showingAddAccount = false
    
    private var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    private var totalMonthlyContribution: Double {
        accounts.reduce(0) { $0 + $1.monthlyContribution }
    }
    
    private var accountModels: [SavingsAccount] {
        accounts.compactMap { SavingsAccount.fromManagedObject($0) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Total Balance Card
                    totalBalanceCard
                    
                    // Bar Chart
                    if !accounts.isEmpty {
                        accountsBarChart
                    }
                    
                    // Account Cards
                    accountCardsSection
                }
                .padding()
            }
            .navigationTitle("Savings Overview")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAccount = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var totalBalanceCard: some View {
        VStack(spacing: 12) {
            Text("Total Savings")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(totalBalance.asCurrency())
                .font(.system(size: 48, weight: .bold, design: .rounded))
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Accounts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(accounts.count)")
                        .font(.title3)
                        .bold()
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(spacing: 4) {
                    Text("Monthly Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(totalMonthlyContribution.asCurrency())
                        .font(.title3)
                        .bold()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    private var accountsBarChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Account Balances")
                .font(.headline)
            
            Chart(accountModels) { account in
                BarMark(
                    x: .value("Account", account.name),
                    y: .value("Balance", account.balance)
                )
                .foregroundStyle(Color(hex: account.colorHex))
                .cornerRadius(6)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let name = value.as(String.self) {
                            Text(name)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let balance = value.as(Double.self) {
                            Text(balance.asCurrency())
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var accountCardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if accounts.isEmpty {
                emptyStateView
            } else {
                Text("Accounts")
                    .font(.headline)
                
                ForEach(accountModels) { account in
                    NavigationLink(destination: AccountDetailView(account: account)) {
                        AccountCardView(account: account)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "banknote")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Savings Accounts")
                .font(.title2)
                .bold()
            
            Text("Add your first savings account to start tracking your progress")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddAccount = true }) {
                Label("Add Account", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
