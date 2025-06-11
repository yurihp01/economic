//
//  economicApp.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

@main
struct economicApp: App {
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ReceiptListView(repository: ReceiptRepository())
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
