//
//  MockFileStorage.swift
//  economic
//
//  Created by Yuri on 12/06/25.
//

import UIKit

final class MockFileStorage: FileStorageProtocol {
    func saveImage(_ image: UIImage, withName name: String) throws -> URL {
        guard image.cgImage != nil else {
            throw ReceiptRepositoryError.imageConversionFailed
        }
        
        return URL(fileURLWithPath: "/tmp/\(name)")
    }
}
