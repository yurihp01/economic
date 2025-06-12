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
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ReceiptListView(dependencies: dependencies)
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
