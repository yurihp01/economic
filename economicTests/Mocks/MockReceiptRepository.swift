//
//  MockReceiptRepository.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import Combine
import UIKit

final class MockReceiptRepository: ReceiptRepositoryProtocol {
    var shouldFail = false

    func saveReceipt(image: UIImage, data: ReceiptExtractedData) -> AnyPublisher<Void, ReceiptRepositoryError> {
        if shouldFail {
            return Fail(error: .coreDataSaveFailed).eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: ReceiptRepositoryError.self)
                .eraseToAnyPublisher()
        }
    }
}
