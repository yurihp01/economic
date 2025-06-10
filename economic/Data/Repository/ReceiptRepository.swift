//
//  ReceiptRepository.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation
import CoreData
import Combine

protocol ReceiptRepositoryProtocol {
    func save(imageData: Data, date: Date, amount: Double, currency: String) -> AnyPublisher<Void, Error>
}

final class ReceiptRepository: ReceiptRepositoryProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }

    func save(imageData: Data, date: Date, amount: Double, currency: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = self.container.newBackgroundContext()
            context.perform {
                let receipt = ReceiptEntity(context: context)
                receipt.id = UUID()
                receipt.imageData = imageData
                receipt.date = date
                receipt.amount = amount
                receipt.currency = currency

                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
