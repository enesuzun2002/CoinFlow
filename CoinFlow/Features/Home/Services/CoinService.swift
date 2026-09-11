//
//  CoinService.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

final class CoinService: CoinServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchCoins(currentPage: Int) async throws -> [Coin] {
        let endpoint = CoinGeckoEndpoint.markets(page: currentPage)
        
        do {
            return try await networkClient.execute(endpoint: endpoint)
        } catch let error as NetworkError {
            throw CoinGeckoError(from: error)
        } catch {
            throw CoinGeckoError.unexpected(error)
        }
    }
}
