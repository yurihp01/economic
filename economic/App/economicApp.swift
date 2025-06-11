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
    let dependencies = AppDependencies()
    let coordinator: Coordinator

    init() {
        self.coordinator = Coordinator(dependencies: dependencies)
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .environmentObject(coordinator)
                .environmentObject(dependencies)
        }
    }
}
