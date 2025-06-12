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

final class ReceiptRepository: ReceiptRepositoryProtocol {
    private let container: NSPersistentContainer
    private let fileStorage: FileStorageProtocol
    
    init(container: NSPersistentContainer, fileStorage: FileStorageProtocol) {
        self.container = container
        self.fileStorage = fileStorage
    }
    
    func saveReceipt(image: UIImage, data: ReceiptExtractedData) -> AnyPublisher<Void, ReceiptRepositoryError> {
        Future { promise in
            let context = self.container.viewContext
            let entity = ReceiptEntity(context: context)
            
            let filename = UUID().uuidString + ".jpg"
            
            do {
                let url = try self.fileStorage.saveImage(image, withName: filename)
                entity.imagePath = url.lastPathComponent
            } catch let error as ReceiptRepositoryError {
                promise(.failure(error))
                return
            } catch {
                promise(.failure(.imageWriteFailed))
                return
            }
            
            entity.id = UUID()
            entity.date = data.date
            entity.amount = data.amount
            entity.currency = data.currency
            
            do {
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.coreDataSaveFailed))
            }
        }.eraseToAnyPublisher()
    }
}
