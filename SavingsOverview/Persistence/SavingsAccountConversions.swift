//
//  SavingsAccountConversions.swift
//  SavingsOverview
//
//  Created on 2025
//

import CoreData

// MARK: - Core Data Conversions
extension SavingsAccount {
    /// Convert Swift model to Core Data managed object
    func toManagedObject(context: NSManagedObjectContext) -> SavingsAccountEntity {
        let entity = SavingsAccountEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.institution = self.institution
        entity.balance = self.balance
        entity.monthlyContribution = self.monthlyContribution
        entity.colorHex = self.colorHex
        entity.createdAt = self.createdAt
        return entity
    }
    
    /// Create Swift model from Core Data managed object
    static func fromManagedObject(_ entity: SavingsAccountEntity) -> SavingsAccount? {
        guard let id = entity.id,
              let name = entity.name,
              let institution = entity.institution,
              let colorHex = entity.colorHex,
              let createdAt = entity.createdAt else {
            return nil
        }
        
        return SavingsAccount(
            id: id,
            name: name,
            institution: institution,
            balance: entity.balance,
            monthlyContribution: entity.monthlyContribution,
            colorHex: colorHex,
            createdAt: createdAt
        )
    }
}

extension SavingsAccountEntity {
    /// Update entity with values from Swift model
    func update(from model: SavingsAccount) {
        self.id = model.id
        self.name = model.name
        self.institution = model.institution
        self.balance = model.balance
        self.monthlyContribution = model.monthlyContribution
        self.colorHex = model.colorHex
        self.createdAt = model.createdAt
    }
}
