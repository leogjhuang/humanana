//
//  CaptureView.swift
//  humanana
//
//  Created by Leo Huang on 2022-09-17.
//

import PhotosUI
import SwiftUI

struct CaptureView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let backgroundGradient = LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?
    
    private var selectedImage: Image? {
        guard let image = selectedUIImage else {
            return nil
        }
        return Image(uiImage: image)
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack(spacing: 36) {
                Text("go bananas!")
                    .font(.custom("Comfortaa", size: 36))
                Divider()
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                        .padding()
                }
                VStack(spacing: 24) {
                    NavigationLink(
                        destination: CameraView(selectedImage: $selectedUIImage),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.black)
                                    .frame(width: 200, height: 50)
                                Text("bananas!")
                                    .foregroundColor(.yellow)
                            }
                        })
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.black)
                                .frame(width: 200, height: 50)
                            Text("choose...")
                                .foregroundColor(.yellow)
                        }
                    }
                    .onChange(of: selectedItem) { newValue in
                        Task {
                            if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                selectedUIImage = image
                            }
                        }
                    }
                    if selectedUIImage != nil {
                        NavigationLink(
                            destination: ResultView(image: selectedUIImage).environmentObject(viewModel),
                            label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 51 / 255, green: 138 / 255, blue: 1 / 255))
                                        .frame(width: 200, height: 50)
                                    Text("confirm")
                                        .foregroundColor(.yellow)
                                }
                            })
                    }
                }
                .font(.custom("Comfortaa", size: 24))
            }
        }
        .foregroundColor(.black)
    }
}

struct CaptureView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureView()
    }
}
