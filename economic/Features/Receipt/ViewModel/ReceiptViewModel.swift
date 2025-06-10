//
//  ReceiptViewModel.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation
import Combine

class ReceiptViewModel: ObservableObject {
    private let repository: ReceiptRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ReceiptRepositoryProtocol = ReceiptRepository()) {
        self.repository = repository
    }
    
    func addReceipt(imageData: Data, date: Date, amount: Double, currency: String, completion: @escaping () -> Void) {
        repository.save(imageData: imageData, date: date, amount: amount, currency: currency)
        .sink(receiveCompletion: { completionState in
            if case let .failure(error) = completionState {
                print("Failed to save receipt: \(error)")
            }
        }, receiveValue: {
            completion()
        })
        .store(in: &cancellables)
    }
}
