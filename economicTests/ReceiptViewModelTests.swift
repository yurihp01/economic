//
//  ReceiptViewModelTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
@testable import economic
import UIKit
import Combine
import CoreData

@MainActor
final class ReceiptViewModelTests: XCTestCase {
    private var viewModel: ReceiptViewModel!
    private var repository: MockReceiptRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = MockReceiptRepository()
        viewModel = ReceiptViewModel(repository: repository)
    }

    func testProcessAndSave_WithValidData_ShouldSucceed() {
        let image = UIImage(systemName: "doc.text")!
        let container = CoreDataTestHelper.inMemoryContainer
        let repository = ReceiptRepository(container: container)
        let viewModel = ReceiptViewModel(repository: repository)
        cancellables = []

        let expectation = XCTestExpectation(description: "Save should succeed")

        viewModel.$errorMessage
            .removeDuplicates()
            .sink { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.processAndSave(image: image)
        wait(for: [expectation], timeout: 2.0)
    }


    func testProcessAndSave_WhenRepositoryFails_ShouldSetErrorMessage() {
        repository.shouldFail = true
        let image = UIImage(systemName: "doc.text")!

        let expectation = XCTestExpectation(description: "Should receive error")

        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.processAndSave(image: image)
        wait(for: [expectation], timeout: 2.0)
    }
}
