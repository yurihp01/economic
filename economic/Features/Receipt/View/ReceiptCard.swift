//
//  ReceiptCard.swift
//  economic
//
//  Created by Yuri on 10/06/25.
//

import SwiftUI

struct ReceiptCard: View {
    let receipt: ReceiptEntity

    var body: some View {
        HStack(spacing: 16) {
            if let data = receipt.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("\(receipt.amount, specifier: "%.2f") \(receipt.currency ?? "")")
                    .font(.headline)

                if let date = receipt.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
