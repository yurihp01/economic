//
//  AddReceiptView.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

struct AddReceiptView: View {
    @StateObject private var viewModel: ReceiptViewModel
    @EnvironmentObject private var coordinator: Coordinator

    private let currencies = ["EUR", "USD", "GBP", "BRL"]
    
    @State private var date = Date()
    @State private var amount = ""
    @State private var currency = "EUR"
    @State private var image: UIImage?
    @State private var imageData: Data?
    @State private var isPresentingImageSourceSheet = false
    @State private var selectedImagePicker: ImagePickerType?
    @State private var imagePickerSource: UIImagePickerController.SourceType = .camera

    init(repository: ReceiptRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: ReceiptViewModel(repository: repository))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ReceiptPhotoSection(
                    isPresentingImageSourceSheet: $isPresentingImageSourceSheet,
                    imageData: $imageData,
                    selectedImagePicker: $selectedImagePicker
                )
                detailsSection
                datePickerSection
                saveButton
            }
            .padding()
        }
        .navigationTitle("Add Receipt")
        .onTapGesture { hideKeyboard() }
        .sheet(item: $selectedImagePicker) { pickerType in
            ImagePicker(sourceType: pickerType.sourceType) { pickedImage in
                DispatchQueue.global(qos: .userInitiated).async {
                    let resized = pickedImage.resize(toWidth: 150)
                    let data = resized.jpegData(compressionQuality: 0.4)
                    DispatchQueue.main.async {
                        self.image = resized
                        self.imageData = data
                    }
                }
            }
        }
    }

    private var saveButton: some View {
        Button(action: saveReceipt) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Receipt")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(canSave ? Color.green : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: canSave ? 5 : 0)
        }
        .disabled(!canSave)
    }

    private var canSave: Bool {
        image != nil && Double(amount) != nil && !currency.isEmpty
    }

    private var detailsSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount")
                    .font(.headline)
                    .foregroundColor(.gray)

                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done", action: hideKeyboard)
                        }
                    }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Currency")
                    .font(.headline)
                    .foregroundColor(.gray)

                Picker("Currency", selection: $currency) {
                    ForEach(currencies, id: \.self, content: Text.init)
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }

    private var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.headline)
                .foregroundColor(.gray)

            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    private func saveReceipt() {
        guard let image = image,
              let doubleAmount = Double(amount) else { return }

        viewModel.save(image: image, date: date, amount: doubleAmount, currency: currency)
        coordinator.pop()
    }
}
