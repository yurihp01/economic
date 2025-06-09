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
        let model = NSManagedObjectModel()

        // Define entidade manualmente
        let entity = NSEntityDescription()
        entity.name = "ReceiptEntity"
        entity.managedObjectClassName = NSStringFromClass(ReceiptEntity.self)

        // Atributos
        var properties: [NSAttributeDescription] = []

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        properties.append(idAttr)

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false
        properties.append(dateAttr)

        let amountAttr = NSAttributeDescription()
        amountAttr.name = "amount"
        amountAttr.attributeType = .doubleAttributeType
        amountAttr.isOptional = false
        properties.append(amountAttr)

        let currencyAttr = NSAttributeDescription()
        currencyAttr.name = "currency"
        currencyAttr.attributeType = .stringAttributeType
        currencyAttr.isOptional = false
        properties.append(currencyAttr)

        let imageDataAttr = NSAttributeDescription()
        imageDataAttr.name = "imageData"
        imageDataAttr.attributeType = .binaryDataAttributeType
        imageDataAttr.isOptional = false
        properties.append(imageDataAttr)

        entity.properties = properties
        model.entities = [entity]

        container = NSPersistentContainer(name: "Receipts", managedObjectModel: model)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data store: \(error)")
            }
        }
    }

    // ✅ FUNÇÃO: buscar dados
    func fetchReceipts() -> [Receipt] {
        let context = container.viewContext
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")

        do {
            let result = try context.fetch(request)
            return result.map {
                Receipt(
                    id: $0.id,
                    imageData: $0.imageData,
                    date: $0.date,
                    amount: $0.amount,
                    currency: $0.currency
                )
            }
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }

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
