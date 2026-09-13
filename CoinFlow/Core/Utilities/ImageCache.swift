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
        // At most 150 images and 50 mb of RAM limit
        cache.name = "ImageCache"
        cache.countLimit = 150
        cache.totalCostLimit = 1024 * 1024 * 50
    }
    
    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
