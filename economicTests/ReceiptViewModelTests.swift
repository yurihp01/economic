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
    private var dependencies: TestAppDependencies!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        dependencies = TestAppDependencies()
        viewModel = ReceiptViewModel(dependencies: dependencies)
    }

    func testProcessAndSave_WithValidData_ShouldSucceed() {
        let image = UIImage(systemName: "doc.text")!

        dependencies.mockExtractor.result = .success(ReceiptExtractedData(
            date: Date(),
            amount: 9.99,
            currency: "EUR"
        ))

        let expectation = XCTestExpectation(description: "Save should succeed")

        var loadingStates: [Bool] = []

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                loadingStates.append(isLoading)

                if loadingStates.count == 2, loadingStates == [true, false] {
                    XCTAssertNil(self.viewModel.errorMessage)
                    XCTAssertTrue(self.dependencies.mockRepository.saveCalled)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.processAndSave(image: image)
        wait(for: [expectation], timeout: 3.0)
    }

    func testProcessAndSave_WhenRepositoryFails_ShouldSetErrorMessage() {
        let image = UIImage(systemName: "doc.text")!

        dependencies.mockExtractor.result = .success(ReceiptExtractedData(
            date: Date(),
            amount: 12.5,
            currency: "USD"
        ))
        dependencies.mockRepository.shouldFail = true

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

    func testProcessAndSave_WhenExtractorFails_ShouldSetErrorMessage() {
        let image = UIImage(systemName: "doc.text")!

        dependencies.mockExtractor.result = .failure(.visionFailed)

        let expectation = XCTestExpectation(description: "OCR failure should set error")

        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                XCTAssertFalse(self.dependencies.mockRepository.saveCalled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.processAndSave(image: image)
        wait(for: [expectation], timeout: 2.0)
    }
}
