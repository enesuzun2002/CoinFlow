//
//  CoinState.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation

struct CoinState: Codable {
    let coins: [Coin]
    let isLoading: Bool
}
