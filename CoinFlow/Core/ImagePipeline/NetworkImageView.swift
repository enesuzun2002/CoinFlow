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

    private var imageLoader: ImageLoader { ImageLoader.shared }

    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var hasError = false

    init(image: String, width: CGFloat?, height: CGFloat?) {
        self.image = image
        self.width = width
        self.height = height

        // Compute cache key synchronously
        let key =
            (width != nil && height != nil)
            ? "\(image)_\(Int(width!))x\(Int(height!))" : image
        // Seed state immediately if already cached
        if let cached = ImageCache.shared.get(forKey: key) {
            _uiImage = State(wrappedValue: cached)
        }
    }

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                Circle()
                    .fill(Color(.systemGray6))
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
            guard uiImage == nil else { return } // Already seeded from cache!
            isLoading = true
            hasError = false
            defer { isLoading = false }
            do {
                uiImage = try await imageLoader.loadImage(
                    image: image,
                    width: width,
                    height: height
                )
            } catch is CancellationError {
                // Ignore SwiftUI task cancellations on fast scroll
                return
            } catch {
                hasError = true
            }

        }
    }
}

#Preview {
    NetworkImageView(
        image:
            "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        width: 100.0,
        height: 100.0
    )
}
