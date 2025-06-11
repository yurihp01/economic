//
//  ReceiptModelFactoryTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
@testable import economic
import CoreData

@MainActor
final class ReceiptModelFactoryTests: XCTestCase {
    func testBuild_createsEntitySuccessfully() {
        let context = CoreDataTestHelper.inMemoryContainer.viewContext
        let data = ReceiptExtractedData(date: Date(), amount: 25.0, currency: "USD")
        let entity = ReceiptModelFactory.build(in: context, from: data)

        XCTAssertEqual(entity.amount, 25.0)
        XCTAssertEqual(entity.currency, "USD")
    }
}
