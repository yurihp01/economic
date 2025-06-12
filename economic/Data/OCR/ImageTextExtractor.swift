//
//  ImageTextExtractor.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Vision
import UIKit
import Combine

protocol ImageTextExtractorProtocol {
    func extractReceipt(from image: UIImage) -> AnyPublisher<ReceiptExtractedData, ImageTextExtractorError>
}

final class ImageTextExtractor: ImageTextExtractorProtocol {
    func extractReceipt(from image: UIImage) -> AnyPublisher<ReceiptExtractedData, ImageTextExtractorError> {
        recognizeText(from: image)
            .tryMap { texts in
                let joined = texts.joined(separator: "\n")
                
                guard let date = TextParsing.extractDate(from: joined) else {
                    throw ImageTextExtractorError.dateNotFound
                }
                
                let rawAmounts = TextParsing.extractAllAmounts(from: joined)
                let parsed: [(value: Double, raw: String)] = rawAmounts.compactMap {
                    guard let value = TextParsing.parseAmount(from: $0) else { return nil }
                    return (value, $0)
                }
                
                guard let highest = parsed.max(by: { $0.value < $1.value }) else {
                    throw ImageTextExtractorError.amountNotFound
                }
                
                let currency = TextParsing.extractCurrency(from: highest.raw)
                return ReceiptExtractedData(date: date, amount: highest.value, currency: currency)
            }
            .mapError { ($0 as? ImageTextExtractorError) ?? .unknown }
            .eraseToAnyPublisher()
    }
}

private extension ImageTextExtractor {
    func recognizeText(from image: UIImage) -> AnyPublisher<[String], ImageTextExtractorError> {
        Future { promise in
            guard let cgImage = image.cgImage else {
                return promise(.failure(.noCGImage))
            }
            
            let request = VNRecognizeTextRequest { req, _ in
                guard let results = req.results as? [VNRecognizedTextObservation] else {
                    return promise(.failure(.visionFailed))
                }
                
                let texts = results.compactMap { $0.topCandidates(1).first?.string }
                promise(.success(texts))
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                } catch {
                    promise(.failure(.visionFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
