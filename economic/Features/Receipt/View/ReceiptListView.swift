//
//  ReceiptListView.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

struct ReceiptListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ReceiptEntity.date, ascending: false)],
        animation: .default
    )
    private var receipts: FetchedResults<ReceiptEntity>
    private let dependencies: AppDependencies
    
    @StateObject private var viewModel: ReceiptViewModel
    @State private var showErrorToast = false
    @State private var selectedImagePicker: ImagePickerType?
    @State private var isShowingImageSourceDialog = false
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: ReceiptViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(receipts) {
                    ReceiptCard(receipt: $0)
                }
            }
            .navigationTitle("Receipts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingImageSourceDialog = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $selectedImagePicker) { pickerType in
                ImagePicker(sourceType: pickerType.sourceType) { pickedImage in
                    viewModel.processAndSave(image: pickedImage)
                }
            }
            .onReceive(viewModel.$errorMessage) { message in
                if message != nil {
                    withAnimation {
                        showErrorToast = true
                        viewModel.errorMessage = nil
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView("Processing...")
                        .foregroundStyle(.blue)
                        .tint(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                }
            }
            .overlay(alignment: .bottom) {
                if showErrorToast, let message = viewModel.errorMessage {
                    ToastView(message: message) {
                        withAnimation {
                            showErrorToast = false
                            viewModel.errorMessage = nil
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .confirmationDialog("Select Image Source", isPresented: $isShowingImageSourceDialog) {
                Button("Camera") { selectedImagePicker = .camera }
                Button("Photo Library") { selectedImagePicker = .photoLibrary }
            }
        }
    }
}
