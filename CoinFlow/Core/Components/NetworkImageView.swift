//
//  NetworkImageView.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 13.09.2026.
//

import SwiftUI

struct NetworkImageView: View {
    let image: String
    let width: CGFloat?
    let height: CGFloat?
    
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var hasError = false
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                ProgressView()
            } else if hasError {
                Image(systemName: "network.slash")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            } else {
                Color.clear
            }
        }
        .frame(width: width, height: height)
        .task(id: image) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard !image.isEmpty, let url = URL(string: image) else {
            hasError = true
            return
        }
        
        // 1. Check cache
        if let cachedImage = ImageCache.shared.get(forKey: image) {
            self.uiImage = cachedImage
            return
        }
        
        // 2. Download
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let downloadedImage = UIImage(data: data) else {
                hasError = true
                return
            }
            
            // 3. Downsample if dimensions are provided
            var finalImage = downloadedImage
            if let width, let height {
                let targetSize = CGSize(width: width * 3, height: height * 3)
                finalImage = await downloadedImage.byPreparingThumbnail(ofSize: targetSize) ?? downloadedImage
            }
            
            // 4. Cache & present once
            ImageCache.shared.set(finalImage, forKey: image)
            self.uiImage = finalImage
        } catch {
            if !Task.isCancelled {
                hasError = true
            }
        }
    }}

#Preview {
    NetworkImageView(image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", width: 100.0, height: 100.0)
}
