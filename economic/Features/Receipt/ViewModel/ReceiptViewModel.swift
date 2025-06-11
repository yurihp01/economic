//
//  ReceiptViewModel.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation
import UIKit

final class ReceiptViewModel: ObservableObject {
    @Published var errorMessage: String?

    private let repository: ReceiptRepositoryProtocol

    init(repository: ReceiptRepositoryProtocol) {
        self.repository = repository
    }

    func save(image: UIImage?, date: Date, amount: Double, currency: String) {
        guard let image = image else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.repository.saveReceipt(image: image, date: date, amount: amount, currency: currency)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
