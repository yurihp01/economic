//
//  ReceiptModelFactory.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import CoreData

struct ReceiptModelFactory {
    static func build(in context: NSManagedObjectContext,
                      from data: ReceiptExtractedData,
                      imagePath: String? = nil) -> ReceiptEntity {
        let entity = ReceiptEntity(context: context)
        entity.id = UUID()
        entity.date = data.date
        entity.amount = data.amount
        entity.currency = data.currency
        entity.imagePath = imagePath
        return entity
    }
}
