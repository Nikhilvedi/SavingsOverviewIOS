//
//  AccountDetailView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

struct AccountDetailView: View {
    let account: SavingsAccount
    @State private var projectionMonths = 12
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Card
                headerCard
                
                // Current Stats
                currentStatsCard
                
                // Projection Chart
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Projection Period")
                            .font(.headline)
                        
                        Spacer()
                        
                        Picker("Months", selection: $projectionMonths) {
                            Text("6 months").tag(6)
                            Text("12 months").tag(12)
                            Text("18 months").tag(18)
                            Text("24 months").tag(24)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    ProjectionChartView(account: account, monthsToProject: projectionMonths)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
                
                // Milestones
                milestonesCard
            }
            .padding()
        }
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditAccountView(account: account)) {
                    Text("Edit")
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color(hex: account.colorHex))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "banknote")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            Text(account.institution)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(account.balance.asCurrency())
                .font(.system(size: 42, weight: .bold, design: .rounded))
            
            Text("Current Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: account.colorHex).opacity(0.1))
        )
    }
    
    private var currentStatsCard: some View {
        VStack(spacing: 16) {
            HStack {
                statItem(
                    icon: "arrow.up.circle.fill",
                    title: "Monthly",
                    value: account.monthlyContribution.asCurrency(),
                    color: Color(hex: account.colorHex)
                )
                
                Divider()
                    .frame(height: 60)
                
                statItem(
                    icon: "calendar",
                    title: "Age",
                    value: accountAge,
                    color: .secondary
                )
            }
            
            Divider()
            
            HStack {
                statItem(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Annual Growth",
                    value: (account.monthlyContribution * 12).asCurrency(),
                    color: .green
                )
                
                Divider()
                    .frame(height: 60)
                
                statItem(
                    icon: "calendar.badge.clock",
                    title: "Created",
                    value: createdDate,
                    color: .secondary
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private func statItem(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var milestonesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Savings Milestones")
                .font(.headline)
            
            ForEach([10000, 25000, 50000, 100000], id: \.self) { milestone in
                if account.balance < Double(milestone) {
                    milestoneRow(target: Double(milestone))
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
    
    private func milestoneRow(target: Double) -> some View {
        let remaining = target - account.balance
        let monthsNeeded = account.monthlyContribution > 0 ? Int(ceil(remaining / account.monthlyContribution)) : 0
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundColor(Color(hex: account.colorHex))
                
                Text(target.asCurrency())
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                Text("\(monthsNeeded) months")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: account.balance, total: target)
                .tint(Color(hex: account.colorHex))
        }
        .padding(.vertical, 4)
    }
    
    private var accountAge: String {
        let components = Calendar.current.dateComponents([.month], from: account.createdAt, to: Date())
        let months = components.month ?? 0
        return months == 1 ? "1 month" : "\(months) months"
    }
    
    private var createdDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: account.createdAt)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AccountDetailView(account: SavingsAccount.sample1)
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
