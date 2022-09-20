//
//  ResultView.swift
//  humanana
//
//  Created by Leo Huang on 2022-09-17.
//

import CoreML
import UIKit
import SwiftUI

extension UIImage {
    public func pixelBufferGray(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer : CVPixelBuffer?
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]

        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(width), Int(height), kCVPixelFormatType_OneComponent8, attributes as CFDictionary, &pixelBuffer)

        guard status == kCVReturnSuccess, let imageBuffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        let imageData =  CVPixelBufferGetBaseAddress(imageBuffer)

        guard let context = CGContext(data: imageData, width: Int(width), height:Int(height),
                                      bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(imageBuffer),
                                      space: CGColorSpaceCreateDeviceGray(),
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
                                        return nil
        }

        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x:0, y:0, width: width, height: height) )
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return imageBuffer
    }
}

struct ResultView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let backgroundGradient = LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
    
    var image: UIImage?
    
    private var result: String {
        isBanana ? "banana" : "human"
    }
    
    private var selectedImage: Image? {
        guard let image = self.image else {
            return nil
        }
        return Image(uiImage: image)
    }
    
    @State private var data: [String: Double] = [:]
    @State private var isBanana = true
    @State private var accuracy = 100.0
    
    func predict() {
        let model = bananaModel()
        guard let image = self.image else {
            return
        }
        do { let p = try
            model.prediction(sequential_input: image.pixelBufferGray(width: 256, height: 256)!)
            data = p.Identity
            accuracy = data["banana"]! - data["human"]!
            if accuracy > 0 {
                isBanana = true
            } else {
                isBanana = false
                accuracy *= -1
            }
        } catch {
            
        }
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack(spacing: 36) {
                Text(result)
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
                    Text("we are \(accuracy * 100)% sure this is a \(result).")
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                    if data["banana"] != nil {
                        Text("banana: \(data["banana"]!)")
                    }
                    if data["human"] != nil {
                        Text("human: \(data["human"]!)")
                    }
                }
                .font(.custom("Comfortaa", size: 24))
            }
        }
        .onAppear {
            predict()
        }
        .foregroundColor(.black)
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
