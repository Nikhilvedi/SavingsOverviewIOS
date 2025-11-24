//
//  AddAccountView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var institution = ""
    @State private var balance = ""
    @State private var monthlyContribution = ""
    @State private var selectedColor = Color.accountColors[0]
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Account Name", text: $name)
                        .autocapitalization(.words)
                    
                    TextField("Institution", text: $institution)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Financial Information")) {
                    HStack {
                        Text("$")
                        TextField("Current Balance", text: $balance)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("$")
                        TextField("Monthly Contribution", text: $monthlyContribution)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section(header: Text("Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(Color.accountColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor.toHex() == color.toHex() ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAccount()
                    }
                    .disabled(!isValid)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty &&
        !institution.isEmpty &&
        Double(balance) != nil &&
        Double(monthlyContribution) != nil
    }
    
    private func saveAccount() {
        guard let balanceValue = Double(balance),
              let contributionValue = Double(monthlyContribution) else {
            errorMessage = "Please enter valid numbers for balance and contribution"
            showingError = true
            return
        }
        
        let newAccount = SavingsAccount(
            name: name,
            institution: institution,
            balance: balanceValue,
            monthlyContribution: contributionValue,
            colorHex: selectedColor.toHex() ?? "#4ECDC4"
        )
        
        let repository = SavingsRepository(context: viewContext)
        
        do {
            try repository.create(newAccount)
            dismiss()
        } catch {
            errorMessage = "Failed to save account: \(error.localizedDescription)"
            showingError = true
        }
    }
}

// MARK: - Preview
#Preview {
    AddAccountView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
