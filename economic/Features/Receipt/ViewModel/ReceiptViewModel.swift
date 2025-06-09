//
//  ReceiptViewModel.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation
import Combine

class ReceiptViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    private let repository: ReceiptRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: ReceiptRepositoryProtocol = ReceiptRepository()) {
        self.repository = repository
        fetchReceipts()
    }

    func fetchReceipts() {
        receipts = repository.fetchAll()
    }

    func addReceipt(imageData: Data, date: Date, amount: Double, currency: String) {
        repository.save(imageData: imageData, date: date, amount: amount, currency: currency)
        fetchReceipts()
    }
}
