//
//  ReceiptViewModel.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

//
//  ReceiptViewModel.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import UIKit
import Combine

@MainActor
final class ReceiptViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let dependencies: AppDependencies
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func processAndSave(image: UIImage) {
        isLoading = true

        dependencies.textExtractor.extractReceipt(from: image)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            } receiveValue: { [weak self] extractedData in
                guard let self else { return }

                self.dependencies.receiptRepository
                    .saveReceipt(image: image, data: extractedData)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        self.isLoading = false
                        if case .failure(let error) = completion {
                            self.errorMessage = error.localizedDescription
                        }
                    } receiveValue: { _ in }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
