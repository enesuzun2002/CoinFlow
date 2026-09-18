//
//  ImageCache.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 13.09.2026.
//

// ImageCache.swift
import UIKit

final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        // At most 100 images and 50 mb of RAM limit
        cache.name = "ImageCache"
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 50
    }

    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        // Calculate image file size in bytes
        let bytesPerRow =
            image.cgImage?.bytesPerRow ?? Int(image.size.width * 4)
        let height = image.cgImage?.height ?? Int(image.size.height)
        let cost = max(1, bytesPerRow * height)
        
        cache.setObject(
            image,
            forKey: key as NSString,
            cost: cost
        )
    }
}
