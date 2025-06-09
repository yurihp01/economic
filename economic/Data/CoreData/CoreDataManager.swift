//
//  CoreDataManager.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import CoreData

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "economic")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data store: \(error)")
            }
        }
    }
//
//    func fetchReceipts() -> [Receipt] {
//        let context = container.viewContext
//        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
//
//        do {
//            let result = try context.fetch(request)
//            return result.map {
//                Receipt(
//                    id: $0.id,
//                    imageData: $0.imageData,
//                    date: $0.date,
//                    amount: $0.amount,
//                    currency: $0.currency
//                )
//            }
//        } catch {
//            print("Fetch failed: \(error)")
//            return []
//        }
//    }

    func saveReceipt(imageData: Data, date: Date, amount: Double, currency: String) {
        let context = container.viewContext
        let receipt = ReceiptEntity(context: context)
        receipt.id = UUID()
        receipt.imageData = imageData
        receipt.date = date
        receipt.amount = amount
        receipt.currency = currency

        do {
            try context.save()
        } catch {
            print("Save failed: \(error)")
        }
    }
}
