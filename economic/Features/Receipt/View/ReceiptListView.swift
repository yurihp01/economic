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
    
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(receipts) { ReceiptCard(receipt: $0) }
                }
                .padding()
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        coordinator.push(page: .addReceipt)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
