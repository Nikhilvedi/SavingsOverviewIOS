//
//  SavingsAccountEntity+CoreDataProperties.swift
//  SavingsOverview
//
//  Created on 2025
//

import Foundation
import CoreData

extension SavingsAccountEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingsAccountEntity> {
        return NSFetchRequest<SavingsAccountEntity>(entityName: "SavingsAccountEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var institution: String?
    @NSManaged public var balance: Double
    @NSManaged public var monthlyContribution: Double
    @NSManaged public var colorHex: String?
    @NSManaged public var createdAt: Date?
}

extension SavingsAccountEntity: Identifiable {
    
}
