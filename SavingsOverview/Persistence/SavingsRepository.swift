//
//  SavingsRepository.swift
//  SavingsOverview
//
//  Created on 2025
//

import CoreData

/// Repository for CRUD operations on SavingsAccount
class SavingsRepository {
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    /// Create a new savings account
    func create(_ account: SavingsAccount) throws {
        let entity = account.toManagedObject(context: viewContext)
        try viewContext.save()
    }
    
    /// Update an existing savings account
    func update(_ account: SavingsAccount) throws {
        let fetchRequest: NSFetchRequest<SavingsAccountEntity> = SavingsAccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", account.id as CVarArg)
        
        if let entity = try viewContext.fetch(fetchRequest).first {
            entity.update(from: account)
            try viewContext.save()
        }
    }
    
    /// Delete a savings account
    func delete(_ account: SavingsAccount) throws {
        let fetchRequest: NSFetchRequest<SavingsAccountEntity> = SavingsAccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", account.id as CVarArg)
        
        if let entity = try viewContext.fetch(fetchRequest).first {
            viewContext.delete(entity)
            try viewContext.save()
        }
    }
    
    /// Delete a savings account entity directly
    func delete(_ entity: SavingsAccountEntity) throws {
        viewContext.delete(entity)
        try viewContext.save()
    }
    
    /// Fetch all savings accounts
    func fetchAll() throws -> [SavingsAccount] {
        let fetchRequest: NSFetchRequest<SavingsAccountEntity> = SavingsAccountEntity.fetchRequest()
        let entities = try viewContext.fetch(fetchRequest)
        return entities.compactMap { SavingsAccount.fromManagedObject($0) }
    }
}
