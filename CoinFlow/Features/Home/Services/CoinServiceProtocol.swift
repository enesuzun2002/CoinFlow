//
//  CoinServiceProtocol.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

protocol CoinServiceProtocol {
    func fetchCoins(currentPage: Int) async throws -> [Coin]
}
