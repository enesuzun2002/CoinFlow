//
//  CoinRowView.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 12.09.2026.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    var body: some View {
        HStack(spacing: 4){
            NetworkImageView(image: coin.image, width: 40.0, height: 40.0).clipShape(Circle()).padding(.trailing, 4)
            VStack(alignment: .leading, spacing: 6) {
                Text(coin.symbol).textCase(.uppercase).font(.subheadline.bold())
                Text(coin.name).font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(coin.currentPrice, format: .currency(code: "USD").precision(.fractionLength(2...6))).font(.subheadline.bold())
                if let priceChange = coin.priceChangePercentage24h {
                    Text(priceChange / 100, format: .percent.precision(.fractionLength(2))).font(.caption.bold()).foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(priceChange > 0 ?  .green : .red ,in: RoundedRectangle(cornerRadius: 4))
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CoinRowView(coin: Coin(id: "", name: "Bitcoin", symbol: "BTC", image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 45500.0, marketCapRank: 1, high24h: nil, low24h: nil, priceChangePercentage24h: -0.95))
}
