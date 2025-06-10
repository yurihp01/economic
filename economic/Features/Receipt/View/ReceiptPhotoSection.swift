//
//  ReceiptPhotoSection.swift
//  economic
//
//  Created by Yuri on 10/06/25.
//

import SwiftUI

struct ReceiptPhotoSection: View {
    @Binding var isPresentingImageSourceSheet: Bool
    @Binding var isPresentingCamera: Bool
    @Binding var imagePickerSource: UIImagePickerController.SourceType
    @Binding var imageData: Data?
    
    var body: some View {
        VStack(spacing: 16) {
            Button {
                isPresentingImageSourceSheet = true
            } label: {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Add Photo")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                .foregroundStyle(.white)
                .cornerRadius(12)
                .shadow(radius: 4)
            }
            .actionSheet(isPresented: $isPresentingImageSourceSheet) {
                ActionSheet(title: Text("Select Photo Source"), buttons: [
                    .default(Text("Camera")) {
                        imagePickerSource = .camera
                        isPresentingCamera = true
                    },
                    .default(Text("Photo Library")) {
                        imagePickerSource = .photoLibrary
                        isPresentingCamera = true
                    },
                    .cancel()
                ])
            }

            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No image selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, minHeight: 180)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(14)
            }
        }
    }
}
