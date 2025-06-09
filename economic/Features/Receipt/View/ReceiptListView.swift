//
//  ReceiptListView.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import SwiftUI

struct ReceiptListView: View {
    @StateObject var viewModel = ReceiptViewModel()
    @State private var navigateToAddReceipt = false

    var body: some View {
        NavigationStack {
            List(viewModel.receipts) { receipt in
                HStack(spacing: 12) {
                    if let image = UIImage(data: receipt.imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(receipt.amount, specifier: "%.2f") \(receipt.currency)")
                            .fontWeight(.semibold)

                        Text(receipt.date.formatted(date: .numeric, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigateToAddReceipt = true
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToAddReceipt) {
                AddReceiptView(viewModel: viewModel)
            }
        }
    }
}
