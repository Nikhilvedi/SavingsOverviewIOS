//
//  EditAccountView.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

struct EditAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let account: SavingsAccount
    
    @State private var name: String
    @State private var institution: String
    @State private var balance: String
    @State private var monthlyContribution: String
    @State private var selectedColor: Color
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDeleteConfirmation = false
    
    init(account: SavingsAccount) {
        self.account = account
        _name = State(initialValue: account.name)
        _institution = State(initialValue: account.institution)
        _balance = State(initialValue: String(format: "%.2f", account.balance))
        _monthlyContribution = State(initialValue: String(format: "%.2f", account.monthlyContribution))
        _selectedColor = State(initialValue: Color(hex: account.colorHex))
    }
    
    var body: some View {
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
                    let selectedHex = selectedColor.toHex()
                    ForEach(Color.accountColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary, lineWidth: selectedHex == color.toHex() ? 3 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Delete Account", systemImage: "trash")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Edit Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .disabled(!isValid)
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .confirmationDialog("Delete Account", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this account? This action cannot be undone.")
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty &&
        !institution.isEmpty &&
        Double(balance) != nil &&
        Double(monthlyContribution) != nil
    }
    
    private func saveChanges() {
        guard let balanceValue = Double(balance),
              let contributionValue = Double(monthlyContribution) else {
            errorMessage = "Please enter valid numbers for balance and contribution"
            showingError = true
            return
        }
        
        let updatedAccount = SavingsAccount(
            id: account.id,
            name: name,
            institution: institution,
            balance: balanceValue,
            monthlyContribution: contributionValue,
            colorHex: selectedColor.toHex() ?? account.colorHex,
            createdAt: account.createdAt
        )
        
        let repository = SavingsRepository(context: viewContext)
        
        do {
            try repository.update(updatedAccount)
            dismiss()
        } catch {
            errorMessage = "Failed to update account: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func deleteAccount() {
        let repository = SavingsRepository(context: viewContext)
        
        do {
            try repository.delete(account)
            dismiss()
        } catch {
            errorMessage = "Failed to delete account: \(error.localizedDescription)"
            showingError = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EditAccountView(account: SavingsAccount.sample1)
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
