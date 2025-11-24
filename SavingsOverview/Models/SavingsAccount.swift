//
//  SavingsAccount.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation

/// Swift model representing a savings account
struct SavingsAccount: Identifiable, Codable {
    var id: UUID
    var name: String
    var institution: String
    var balance: Double
    var monthlyContribution: Double
    var colorHex: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        institution: String,
        balance: Double,
        monthlyContribution: Double,
        colorHex: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.institution = institution
        self.balance = balance
        self.monthlyContribution = monthlyContribution
        self.colorHex = colorHex
        self.createdAt = createdAt
    }
    
    /// Calculate projected balance for a given number of months
    func projectedBalance(months: Int) -> Double {
        return balance + (monthlyContribution * Double(months))
    }
}

// MARK: - Sample Data for Previews
extension SavingsAccount {
    static let sample1 = SavingsAccount(
        name: "Emergency Fund",
        institution: "Chase Bank",
        balance: 5000.0,
        monthlyContribution: 500.0,
        colorHex: "#FF6B6B"
    )
    
    static let sample2 = SavingsAccount(
        name: "Vacation Fund",
        institution: "Wells Fargo",
        balance: 2500.0,
        monthlyContribution: 250.0,
        colorHex: "#4ECDC4"
    )
    
    static let sample3 = SavingsAccount(
        name: "House Down Payment",
        institution: "Bank of America",
        balance: 15000.0,
        monthlyContribution: 1000.0,
        colorHex: "#95E1D3"
    )
    
    static let samples = [sample1, sample2, sample3]
}
