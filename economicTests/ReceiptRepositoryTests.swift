//
//  ReceiptRepositoryTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
import CoreData
import UIKit
import Combine
@testable import economic

@MainActor
final class ReceiptRepositoryTests: XCTestCase {
    var sut: ReceiptRepository!
    var container: NSPersistentContainer!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        container = CoreDataTestHelper.inMemoryContainer
        sut = ReceiptRepository(container: container)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        container = nil
        cancellables = nil
        super.tearDown()
    }

    func test_saveReceipt_successfullySaves() {
        let expectation = expectation(description: "Save receipt")

        let sampleImage = UIImage(systemName: "photo")!
        let extractedData = ReceiptExtractedData(
            date: Date(),
            amount: 42.0,
            currency: "USD"
        )

        sut.saveReceipt(image: sampleImage, data: extractedData)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: {
                let request: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
                let results = try? self.container.viewContext.fetch(request)
                XCTAssertEqual(results?.count, 1)
                XCTAssertEqual(results?.first?.amount, extractedData.amount)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    func test_saveReceipt_imageConversionFails() {
        let expectation = expectation(description: "Fail to convert image")
        let extractedData = ReceiptExtractedData(
            date: Date(),
            amount: 20.0,
            currency: "EUR"
        )

        let invalidImage = UIImage()

        sut.saveReceipt(image: invalidImage, data: extractedData)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, ReceiptRepositoryError.imageConversionFailed)
                    expectation.fulfill()
                }
            } receiveValue: {
                XCTFail("Should not succeed")
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
}
