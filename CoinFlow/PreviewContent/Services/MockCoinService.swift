//
//  MockCoinService.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 13.09.2026.
//


// MockCoinService.swift
import Foundation

struct MockCoinService: CoinServiceProtocol {
    var result: Result<[Coin], Error> = .success(Coin.mockList)
    var delayNanoseconds: UInt64 = 0 // İstersen yükleme animasyonunu test etmek için gecikme verebilirsin
    
    func fetchCoins(page: Int) async throws -> [Coin] {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }
        
        switch result {
        case .success(let coins):
            return coins
        case .failure(let error):
            throw error
        }
    }
}
