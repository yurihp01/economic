//
//  ImageTextExtractorTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
import UIKit
import Combine
@testable import economic

final class ImageTextExtractorTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    func testExtractReceipt_returnsFailureForInvalidImage() {
        let extractor = ImageTextExtractor()
        let image = UIImage()
        let expectation = XCTestExpectation(description: "Should return failure for invalid image")
        
        extractor.extractReceipt(from: image)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got value")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3.0)
    }
}
