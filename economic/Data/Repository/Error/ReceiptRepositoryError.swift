//
//  ReceiptRepositoryError.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Foundation

enum ReceiptRepositoryError: LocalizedError, Equatable {
    static func == (lhs: ReceiptRepositoryError, rhs: ReceiptRepositoryError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
    
    case imageConversionFailed
    case imageWriteFailed
    case coreDataSaveFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "Failed to convert the image for saving."
        case .imageWriteFailed:
            return "Failed to write the image to disk."
        case .coreDataSaveFailed:
            return "Failed to save the receipt to the database."
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
}
