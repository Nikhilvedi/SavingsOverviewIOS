//
//  CurrencyFormatter.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation

extension Double {
    /// Format as currency
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}

extension Int {
    /// Format as currency
    func asCurrency() -> String {
        Double(self).asCurrency()
    }
}
