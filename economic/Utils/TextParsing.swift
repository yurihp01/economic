//
//  TextParsing.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Foundation

struct TextParsing {
    
    private static let dateFormats = [
        "dd/MM/yyyy", "d/M/yyyy", "dd/M/yyyy", "d/MM/yyyy",
        "yyyy/MM/dd", "yyyy/M/d", "yyyy/MM/d", "yyyy/M/dd"
    ]
    
    static func extractDate(from text: String) -> Date? {
        let pattern = #"(?<!\d)(\d{1,2}[./-]\d{1,2}[./-]\d{4})(?!\d)|(?<!\d)(\d{4}[./-]\d{1,2}[./-]\d{1,2})(?!\d)"#
        guard let dateString = matchRegex(text, pattern: pattern)?
                .replacingOccurrences(of: ".", with: "/")
                .replacingOccurrences(of: "-", with: "/") else {
            return nil
        }

        return dateFormats.compactMap { format in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.date(from: dateString)
        }.first
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
        let amount = raw
            .replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "£", with: "")
            .replacingOccurrences(of: "EUR", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "USD", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "GBP", with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespaces)

        return Double(amount)
    }
    
    static func extractCurrency(from raw: String) -> String {
        if raw.contains("€") || raw.localizedCaseInsensitiveContains("EUR") { return "EUR" }
        if raw.contains("$") || raw.localizedCaseInsensitiveContains("USD") { return "USD" }
        if raw.contains("£") || raw.localizedCaseInsensitiveContains("GBP") { return "GBP" }
        return "UNDEF"
    }
    
    private static func matchRegex(_ text: String, pattern: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let range = Range(match.range, in: text) else {
            return nil
        }
        return String(text[range])
    }
}

