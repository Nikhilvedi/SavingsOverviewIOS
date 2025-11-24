//
//  ProjectionChartView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI
import Charts

/// Reusable view to display balance projection chart
struct ProjectionChartView: View {
    let account: SavingsAccount
    let monthsToProject: Int
    
    init(account: SavingsAccount, monthsToProject: Int = 12) {
        self.account = account
        self.monthsToProject = min(monthsToProject, 24)
    }
    
    private var projectionData: [ProjectionPoint] {
        var data: [ProjectionPoint] = []
        for month in 0...monthsToProject {
            let balance = account.projectedBalance(months: month)
            data.append(ProjectionPoint(month: month, balance: balance))
        }
        return data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Balance Projection")
                .font(.headline)
            
            Chart(projectionData) { point in
                LineMark(
                    x: .value("Month", point.month),
                    y: .value("Balance", point.balance)
                )
                .foregroundStyle(Color(hex: account.colorHex))
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Month", point.month),
                    y: .value("Balance", point.balance)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: account.colorHex).opacity(0.3), Color(hex: account.colorHex).opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: 3)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let month = value.as(Int.self) {
                            Text("\(month)m")
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
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(account.balance.asCurrency())
                        .font(.subheadline)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("After \(monthsToProject) months")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(account.projectedBalance(months: monthsToProject).asCurrency())
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color(hex: account.colorHex))
                }
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Supporting Types
struct ProjectionPoint: Identifiable {
    let id = UUID()
    let month: Int
    let balance: Double
}

// MARK: - Preview
#Preview {
    ProjectionChartView(account: SavingsAccount.sample1, monthsToProject: 12)
        .padding()
}
