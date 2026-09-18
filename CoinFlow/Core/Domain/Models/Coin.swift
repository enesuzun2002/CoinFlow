//
//  Coin.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

struct Coin: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int?
    let high24h: Double?
    let low24h: Double?
    let priceChangePercentage24h: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }

    // MARK: - Formatted Presentation Properties

    var formattedPrice: String {
        currentPrice.formatted(Self.priceFormat)
    }

    var formattedPriceChange: String? {
        guard let change = priceChangePercentage24h else { return nil }
        return (change / 100).formatted(Self.percentFormat)
    }

    var isPositiveChange: Bool {
        (priceChangePercentage24h ?? 0) > 0
    }

    // MARK: - Static Reusable Formatters

    private static let priceFormat = FloatingPointFormatStyle<Double>.Currency(
        code: "USD"
    )
    .precision(.fractionLength(2...6))

    private static let percentFormat = FloatingPointFormatStyle<Double>
        .Percent()
        .precision(.fractionLength(2))
}

extension Coin {
    static let mock = Coin(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "BTC",
        image:
            "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 64250.0,
        marketCapRank: 1,
        high24h: 65000.0,
        low24h: 63800.0,
        priceChangePercentage24h: 2.45
    )

    static let mockList: [Coin] = [
        .mock,
        Coin(
            id: "ethereum",
            name: "Ethereum",
            symbol: "ETH",
            image:
                "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628",
            currentPrice: 3450.0,
            marketCapRank: 2,
            high24h: nil,
            low24h: nil,
            priceChangePercentage24h: -1.12
        ),
        Coin(
            id: "solana",
            name: "Solana",
            symbol: "SOL",
            image:
                "https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1696504756",
            currentPrice: 142.8,
            marketCapRank: 3,
            high24h: nil,
            low24h: nil,
            priceChangePercentage24h: 8.74
        ),
    ]
}
