//
//  ReceiptEntity.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import CoreData

@objc(ReceiptEntity)
final class ReceiptEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageData: Data
    @NSManaged var date: Date
    @NSManaged var amount: Double
    @NSManaged var currency: String
}

