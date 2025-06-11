//
//  TextParsingTests.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import XCTest
@testable import economic

final class TextParsingTests: XCTestCase {

    func testExtractCurrency_EUR() {
        let result = TextParsing.extractCurrency(from: "€123.45")
        XCTAssertEqual(result, "EUR")
    }

    func testExtractCurrency_USD() {
        let result = TextParsing.extractCurrency(from: "$123.45")
        XCTAssertEqual(result, "USD")
    }

    func testExtractCurrency_GBP() {
        let result = TextParsing.extractCurrency(from: "£123.45")
        XCTAssertEqual(result, "GBP")
    }

    func testParseAmount_WithCommaAndSpace() {
        let result = TextParsing.parseAmount(from: "€ 1 234,56") ?? 0.0
        XCTAssertEqual(result, 1234.56, accuracy: 0.001)
    }

    func testExtractDate_SupportedFormat() {
        let input = "Date: 27/12/2023"
        let result = TextParsing.extractDate(from: input)
        XCTAssertNotNil(result)
    }

    func testExtractDate_FullMonthNameFormat() {
        let input = "December 12, 2023"
        let result = TextParsing.extractDate(from: input)
        XCTAssertNotNil(result)
    }

    func testExtractAllAmounts_ShouldReturnAllValidMatches() {
        let input = "Total: €45.00\nSubtotal: €40.00"
        let results = TextParsing.extractAllAmounts(from: input)
        XCTAssertTrue(results.contains("€45.00"))
        XCTAssertTrue(results.contains("€40.00"))
    }
}
