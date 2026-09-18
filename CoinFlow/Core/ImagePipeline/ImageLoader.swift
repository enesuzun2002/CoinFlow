//
//  ImageLoader.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 18.09.2026.
//

import Foundation
import UIKit

enum ImageLoaderError: LocalizedError, Equatable {
    case invalidURL(String)
    case requestFailed(underlying: String)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid image URL: '\(urlString)'"
        case .requestFailed(let message):
            return "Image download failed: \(message)"
        case .decodingFailed:
            return "Unable to decode image data into a valid image."
        }

    }
}

actor ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    // 1. In-flight request dictionary
    private var inFlightRequests: [String: Task<UIImage, Error>] = [:]

    func loadImage(image: String, width: CGFloat?, height: CGFloat?)
        async throws -> UIImage
    {
        guard !image.isEmpty, let url = URL(string: image) else {
            throw (ImageLoaderError.invalidURL(image))
        }

        let cacheKey: String
        if let width, let height {
            cacheKey = "\(image)_\(Int(width))x\(Int(height))"
        } else {
            cacheKey = image
        }

        // 2. Check memory/disk cache first
        if let cachedImage = await ImageCache.shared.get(forKey: cacheKey) {
            return cachedImage
        }

        // 3. Deduplicate: Return running task if one already exists
        if let existingTask = inFlightRequests[cacheKey] {
            return try await existingTask.value
        }

        // 4. Create a new task and store it in flight
        let downloadTask = Task<UIImage, Error> { [weak self] in
            // Clean up the dictionary inside the task when it finishes or fails,
            // NOT in the caller's defer block
            defer {
                Task { [weak self] in
                    await self?.removeInFlightRequest(forKey: cacheKey)
                }
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloadedImage = UIImage(data: data) else {
                throw ImageLoaderError.decodingFailed
            }

            var finalImage = downloadedImage
            if let width, let height {
                let targetSize = CGSize(width: width * 3, height: height * 3)
                finalImage =
                    await downloadedImage.byPreparingThumbnail(
                        ofSize: targetSize
                    ) ?? downloadedImage
            }

            await ImageCache.shared.set(finalImage, forKey: cacheKey)
            return finalImage
        }

        inFlightRequests[cacheKey] = downloadTask

        return try await downloadTask.value
    }

    private func removeInFlightRequest(forKey key: String) {
        inFlightRequests[key] = nil
    }
}
