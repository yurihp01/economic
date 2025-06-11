//
//  CoordinatorView.swift
//  economic
//
//  Created by Yuri on 09/06/25.
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var dependencies: AppDependencies

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .receipts)
                .navigationDestination(for: AppPages.self) { pages in
                    coordinator.build(page: pages)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                    coordinator.build(cover: cover)
                }
        }
        .environmentObject(coordinator)
    }
}
