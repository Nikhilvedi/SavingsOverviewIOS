//
//  AccountCardView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

/// Reusable card view for displaying account summary
struct AccountCardView: View {
    let account: SavingsAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(hex: account.colorHex))
                    .frame(width: 12, height: 12)
                
                Text(account.name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(account.institution)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline) {
                Text(account.balance.asCurrency())
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.caption2)
                        Text(account.monthlyContribution.asCurrency())
                            .font(.caption)
                    }
                    .foregroundColor(Color(hex: account.colorHex))
                    
                    Text("/month")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: account.colorHex).opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: account.colorHex).opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack {
        AccountCardView(account: SavingsAccount.sample1)
        AccountCardView(account: SavingsAccount.sample2)
        AccountCardView(account: SavingsAccount.sample3)
    }
    .padding()
}
