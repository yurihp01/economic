//
//  FileStorage.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import UIKit

protocol FileStorageProtocol {
    func saveImage(_ image: UIImage, withName name: String) throws -> URL
}

final class FileStorage: FileStorageProtocol {
    func saveImage(_ image: UIImage, withName name: String) throws -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(name)

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ReceiptRepositoryError.imageConversionFailed
        }

        try imageData.write(to: url)
        return url
    }
}
