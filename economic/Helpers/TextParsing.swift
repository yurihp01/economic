//
//  TextParsing.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Foundation

enum TextParsing {
    private static let dateFormats = [
        "dd/MM/yyyy", "d/M/yyyy", "MM/dd/yyyy", "M/d/yyyy",
        "yyyy/MM/dd", "yyyy/M/d", "MMMM d, yyyy"
    ]
    
    static func extractDate(from text: String) -> Date? {
        let patterns = [
            "\\b\\d{1,2}[./-]\\d{1,2}[./-]\\d{2,4}\\b",
            "\\b\\d{4}[./-]\\d{1,2}[./-]\\d{1,2}\\b",
            "\\b[a-zA-Z]+ \\d{1,2}, \\d{4}\\b"
        ]

        let normalizedText = text
            .replacingOccurrences(of: "-", with: "/")
            .replacingOccurrences(of: ".", with: "/")

        for pattern in patterns {
            if let dateString = matchRegex(normalizedText, pattern: pattern) {
                for format in dateFormats {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = format

                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
            }
        }

        return nil
    }

    static func extractAllAmounts(from text: String) -> [String] {
        let pattern = "(€|\\$|£|EUR|USD|GBP|eur|usd|gbp)?\\s*\\d{1,3}(?:[\\s.,]?\\d{3})*[.,]\\d{2}\\b"

        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(text.startIndex..., in: text)
        
        let matches = regex.matches(in: text, range: range)
        return matches.compactMap {
            Range($0.range, in: text).map { String(text[$0]) }
        }
    }
    
    static func parseAmount(from raw: String) -> Double? {
        Double(raw
            .replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "£", with: "")
            .replacingOccurrences(of: "EUR", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "USD", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "GBP", with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespaces))
    }
    
    static func extractCurrency(from raw: String) -> String {
        if raw.contains("€") || raw.localizedCaseInsensitiveContains("EUR") { return "EUR" }
        if raw.contains("$") || raw.localizedCaseInsensitiveContains("USD") { return "USD" }
        if raw.contains("£") || raw.localizedCaseInsensitiveContains("GBP") { return "GBP" }
        return "UNDEF"
    }
    
    
}

private extension TextParsing {
    static func matchRegex(_ text: String, pattern: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let range = Range(match.range, in: text) else {
            return nil
        }
        return String(text[range])
    }
}
