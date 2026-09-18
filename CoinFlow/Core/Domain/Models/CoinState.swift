//
//  CoinState.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation

enum CoinState: Equatable {
    case idle
    case initialLoading
    case loaded(Content)
    case failed(message: String)

    struct Content: Equatable {
        var coins: [Coin]
        var currentPage: Int = 1
        var isPaginating: Bool = false
        var isLastPage: Bool = false
    }
}
