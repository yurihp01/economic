//
//  ReceiptRepository.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import CoreData
import SwiftUI
import Combine

protocol ReceiptRepositoryProtocol {
    func saveReceipt(image: UIImage, data: ReceiptExtractedData) -> AnyPublisher<Void, ReceiptRepositoryError>
}

import CoreData
import Combine
import SwiftUI

final class ReceiptRepository: ReceiptRepositoryProtocol {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func saveReceipt(image: UIImage, data: ReceiptExtractedData) -> AnyPublisher<Void, ReceiptRepositoryError> {
        Future { promise in
            let context = self.container.viewContext
            let entity = ReceiptEntity(context: context)
            
            let filename = UUID().uuidString + ".jpg"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(filename)
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                promise(.failure(.imageConversionFailed))
                return
            }
            
            do {
                try imageData.write(to: url)
            } catch {
                promise(.failure(.imageWriteFailed))
                return
            }
            
            entity.id = UUID()
            entity.date = data.date
            entity.amount = data.amount
            entity.currency = data.currency
            entity.imagePath = filename
            
            print("[DEBUG] Saving receipt with path: \(filename)")
            do {
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.coreDataSaveFailed))
            }
        }.eraseToAnyPublisher()
    }
}
