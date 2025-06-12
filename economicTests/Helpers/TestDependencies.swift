//
//  TestDependencies.swift
//  economic
//
//  Created by Yuri on 12/06/25.
//

import Foundation

final class TestAppDependencies: AppDependencies {
    override init() {
        let mockRepository = MockReceiptRepository()
        let mockExtractor = MockImageTextExtractor()

        super.init()

        self.receiptRepository = mockRepository
        self.textExtractor = mockExtractor
    }

    var mockRepository: MockReceiptRepository {
        return receiptRepository as! MockReceiptRepository
    }

    var mockExtractor: MockImageTextExtractor {
        return textExtractor as! MockImageTextExtractor
    }
}
