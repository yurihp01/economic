//
//  ImageTextExtractorTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
@testable import economic
import UIKit

final class ImageTextExtractorTests: XCTestCase {
    func testExtractReceipt_returnsFailureForInvalidImage() {
        let image = UIImage()
        let expectation = XCTestExpectation(description: "Image is not valid")

        _ = ImageTextExtractor.extractReceipt(from: image)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })

        wait(for: [expectation], timeout: 3.0)
    }
}
