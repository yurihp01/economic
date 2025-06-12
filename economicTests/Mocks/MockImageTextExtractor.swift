//
//  MockImageTextExtractor.swift
//  economic
//
//  Created by Yuri on 12/06/25.
//

import Combine
import UIKit

final class MockImageTextExtractor: ImageTextExtractorProtocol {
    var result: Result<ReceiptExtractedData, ImageTextExtractorError> = .failure(.unknown)

    func extractReceipt(from image: UIImage) -> AnyPublisher<ReceiptExtractedData, ImageTextExtractorError> {
        return result.publisher
            .eraseToAnyPublisher()
    }
}
