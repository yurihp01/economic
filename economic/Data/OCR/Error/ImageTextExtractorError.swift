//
//  ImageTextExtractorError.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Foundation

enum ImageTextExtractorError: LocalizedError {
    case noCGImage
    case visionFailed
    case dateNotFound
    case amountNotFound
    case amountInvalid
    case unknown

    var errorDescription: String? {
        switch self {
        case .noCGImage:
            return "Unable to process the image."
        case .visionFailed:
            return "Failed to recognize text from the image."
        case .dateNotFound:
            return "No date found in the receipt."
        case .amountNotFound:
            return "No amount found in the receipt."
        case .amountInvalid:
            return "The extracted amount is invalid."
        case .unknown:
            return "An unknown error occurred while extracting receipt data."
        }
    }
}
