//
//  CoinState.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation

struct CoinState {
    var coins: [Coin]
    var isLoading: Bool
    var errorMessage: String?
    var currentPage: Int = 1
    var isLastPage: Bool = false
}
