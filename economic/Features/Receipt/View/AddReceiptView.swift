//
//  AddReceiptView.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

struct AddReceiptView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ReceiptViewModel

    private let currencies = ["EUR", "USD", "GBP", "BRL"]
    @State private var date = Date()
    @State private var amount = ""
    @State private var currency = "EUR"
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        Form {
            photoSection
            detailsSection
            DatePicker("Date", selection: $date, displayedComponents: .date)
        }
        .navigationTitle("New Receipt")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveReceipt)
                    .disabled(!canSave)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: dismiss.callAsFunction)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }

    private var photoSection: some View {
        Section(header: Text("Photo")) {
            Button("Take Photo") {
                showImagePicker = true
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Group {
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .overlay(Text("No image selected").foregroundColor(.gray))
                }
            }
        }
    }

    private var detailsSection: some View {
        Section(header: Text("Details")) {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)

            Picker("Currency", selection: $currency) {
                ForEach(currencies, id: \.self, content: Text.init)
            }
            .pickerStyle(.menu)
        }
    }

    private var canSave: Bool {
        inputImage != nil && Double(amount) != nil && !currency.isEmpty
    }

    private func saveReceipt() {
        guard let image = inputImage,
              let data = image.jpegData(compressionQuality: 0.8),
              let doubleAmount = Double(amount) else { return }

        viewModel.addReceipt(imageData: data, date: date, amount: doubleAmount, currency: currency)
        dismiss()
    }
}

