//
//  Coordinator.swift
//  economic
//
//  Created by Yuri on 09/06/25.
//

import SwiftUI

class Coordinator: ObservableObject {
    private var dependencies: AppDependencies
    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?
    
    init(dependencies: AppDependencies) {
       self.dependencies = dependencies
   }

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
        case .receipts: ReceiptListView()
        case .addReceipt: AddReceiptView(repository: dependencies.receiptRepository)
        }
    }
    
    @ViewBuilder
    func build(cover: FullScreenCover) -> some View {
        switch cover {
        case .camera(let image): ImagePicker(onImagePicked: image)
        }
    }
}
