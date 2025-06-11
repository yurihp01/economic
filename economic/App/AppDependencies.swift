//
//  AppDependencies.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import Foundation
import CoreData

final class AppDependencies: ObservableObject {
    let receiptRepository: ReceiptRepositoryProtocol

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.receiptRepository = ReceiptRepository(container: container)
    }
}
