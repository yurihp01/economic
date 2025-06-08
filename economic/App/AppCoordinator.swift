//
//  AppCoordinator.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

class AppCoordinator {
    func start() -> some View {
        ReceiptListView(viewModel: .init())
    }
}
