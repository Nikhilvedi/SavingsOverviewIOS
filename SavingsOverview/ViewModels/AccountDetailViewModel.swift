//
//  AccountDetailViewModel.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation

@MainActor
class AccountDetailViewModel: ObservableObject {
    @Published var projectionMonths = 12
    @Published var account: SavingsAccount
    
    init(account: SavingsAccount) {
        self.account = account
    }
    
    // MARK: - Computed Properties
    
    var currentBalance: Double {
        account.balance
    }
    
    var monthlyContribution: Double {
        account.monthlyContribution
    }
    
    var annualGrowth: Double {
        monthlyContribution * 12
    }
    
    var accountAge: String {
        let components = Calendar.current.dateComponents([.month], from: account.createdAt, to: Date())
        let months = components.month ?? 0
        return months == 1 ? "1 month" : "\(months) months"
    }
    
    var createdDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: account.createdAt)
    }
    
    var projectedBalance: Double {
        account.projectedBalance(months: projectionMonths)
    }
    
    // MARK: - Projection Data
    
    func projectionData() -> [ProjectionDataPoint] {
        var data: [ProjectionDataPoint] = []
        for month in 0...projectionMonths {
            let balance = account.projectedBalance(months: month)
            data.append(ProjectionDataPoint(month: month, balance: balance))
        }
        return data
    }
    
    // MARK: - Milestones
    
    var milestones: [Milestone] {
        let targets = [10000.0, 25000.0, 50000.0, 100000.0]
        return targets.compactMap { target in
            guard account.balance < target else { return nil }
            
            let remaining = target - account.balance
            let monthsNeeded = account.monthlyContribution > 0 
                ? Int(ceil(remaining / account.monthlyContribution))
                : 0
            
            return Milestone(
                target: target,
                progress: account.balance / target,
                monthsToReach: monthsNeeded
            )
        }
    }
}

// MARK: - Supporting Types

struct ProjectionDataPoint: Identifiable {
    let id = UUID()
    let month: Int
    let balance: Double
}

struct Milestone: Identifiable {
    let id = UUID()
    let target: Double
    let progress: Double
    let monthsToReach: Int
}
