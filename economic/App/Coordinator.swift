//
//  Coordinator.swift
//  economic
//
//  Created by Yuri on 09/06/25.
//

import SwiftUI

class Coordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?

    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover) {
        self.fullScreenCover = cover
    }
    
    func dismissCover() {
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .receipts: ReceiptListView(viewModel: .init())
        case .addReceipt: AddReceiptView(viewModel: .init())
        }
    }
    
    @ViewBuilder
    func build(cover: FullScreenCover) -> some View {
        switch cover {
        case .camera(let image): ImagePicker(image: image)
        }
    }
}
