//
//  AppDependencies.swift
//  economic
//
//  Created by Yuri on 12/06/25.
//

import Foundation
import CoreData

class AppDependencies: ObservableObject {
    var receiptRepository: ReceiptRepositoryProtocol
    var textExtractor: ImageTextExtractorProtocol
    var container: NSPersistentContainer
    var fileStorage: FileStorageProtocol

    init() {
        container = PersistenceController.shared.container
        fileStorage = FileStorage()
        receiptRepository = ReceiptRepository(container: container, fileStorage: fileStorage)
        textExtractor = ImageTextExtractor()
    }
}
