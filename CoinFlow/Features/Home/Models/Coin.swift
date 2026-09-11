//
//  Coin.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

struct Coin: Identifiable, Codable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int?
    let high24h: Double?
    let low24h: Double?
    let priceChangePercentage24h: Double?
}
