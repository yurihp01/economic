//
//  ImagePreviewSheet.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import SwiftUI

struct ImagePreviewSheet: View {
    @Binding var expandedImage: IdentifiableImage?
    var image: UIImage
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()

            Button(action: {
                expandedImage = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
}
