//
//  ReceiptRepository.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation

protocol ReceiptRepositoryProtocol {
    func fetchAll() -> [Receipt]
    func save(imageData: Data, date: Date, amount: Double, currency: String)
}

class ReceiptRepository: ReceiptRepositoryProtocol {
    private let manager = CoreDataManager.shared

    func fetchAll() -> [Receipt] {
        manager.fetchReceipts()
    }

    func save(imageData: Data, date: Date, amount: Double, currency: String) {
        manager.saveReceipt(imageData: imageData, date: date, amount: amount, currency: currency)
    }
}
