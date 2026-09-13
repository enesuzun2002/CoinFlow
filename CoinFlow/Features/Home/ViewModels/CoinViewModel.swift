//
//  CoinViewModel.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation

@Observable
@MainActor
final class CoinViewModel {
    var state: CoinState
    
    private let service: CoinServiceProtocol
    
    init(
        state: CoinState = CoinState(coins: [], isLoading: false),
        service: CoinServiceProtocol
    ) {
        self.state = state
        self.service = service
    }
    
    func fetchNextPageIfNeeded(for coin: Coin) async {
        // 1. Only trigger if the coin that just appeared is the very last item in the list
        guard coin.id == state.coins.last?.id else { return }
            
        // 2. Prevent concurrent duplicate fetches and respect end of data
        guard !state.isLoading && !state.isLastPage else { return }

        state.currentPage += 1
        await fetchCoins()
        }
    
    func fetchCoins() async {
        state.isLoading = true
        defer { state.isLoading = false }
         
        do {
            let newCoins = try await service.fetchCoins(page: state.currentPage)
            
            if newCoins.isEmpty {
                state.isLastPage = true
                return
            }
             
            // CoinViewModel.swift içindeki do bloğu:
            if state.currentPage == 1 {
                state.coins = newCoins
            } else {
                // Zaten listede olan coinleri filtrele (duplicate engelleme)
                let existingIDs = Set(state.coins.map(\.id))
                let uniqueNewCoins = newCoins.filter { !existingIDs.contains($0.id) }
                state.coins.append(contentsOf: uniqueNewCoins)
            }
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    func refreshCoins() async {
        state.currentPage = 1
        state.isLastPage = false
        await fetchCoins()
    }
}
