//
//  ReceiptRepository.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation
import CoreData
import SwiftUI

protocol ReceiptRepositoryProtocol {
    func saveReceipt(image: UIImage, date: Date, amount: Double, currency: String) throws
}

final class ReceiptRepository: ReceiptRepositoryProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }

    func saveReceipt(image: UIImage, date: Date, amount: Double, currency: String) throws {
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG."])
        }

        try data.write(to: url)

        let context = container.viewContext
        let entity = ReceiptEntity(context: context)
        entity.id = UUID()
        entity.date = date
        entity.amount = amount
        entity.currency = currency
        entity.imagePath = filename

        try context.save()
    }
}
