//
//  ContentView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            AccountListView()
                .tabItem {
                    Label("Accounts", systemImage: "list.bullet")
                }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
