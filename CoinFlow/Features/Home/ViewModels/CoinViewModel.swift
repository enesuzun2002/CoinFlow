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
        state: CoinState = .idle,
        service: CoinServiceProtocol
    ) {
        self.state = state
        self.service = service
    }

    func loadInitialCoins() async {
        guard state == .idle else { return }
        state = .initialLoading

        do {
            let coins = try await service.fetchCoins(page: 1)
            state = .loaded(
                CoinState.Content(
                    coins: coins,
                    currentPage: 1,
                    isLastPage: coins.isEmpty
                )
            )
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }

    func refreshCoins() async {
        do {
            let coins = try await service.fetchCoins(page: 1)
            state = .loaded(
                CoinState.Content(
                    coins: coins,
                    currentPage: 1,
                    isLastPage: coins.isEmpty
                )
            )
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }

    func fetchNextPageIfNeeded(for coin: Coin) async {
        // Extract content; only paginate if we are in the .loaded phase
        guard case .loaded(var content) = state else { return }

        // Prevent duplicate loads or loading beyond last page
        guard !content.isPaginating && !content.isLastPage else { return }
        
        // Only fetch next page if we are at the last item
        guard coin.id == content.coins.last?.id else { return }

        // 1. Mark pagination in progress (shows footer spinner)
        content.isPaginating = true
        state = .loaded(content)

        do {
            let nextPage = content.currentPage + 1
            let newCoins = try await service.fetchCoins(page: nextPage)

            guard case .loaded(var currentContent) = state else { return }

            if newCoins.isEmpty {
                currentContent.isLastPage = true
            } else {
                let existingIDs = Set(currentContent.coins.map(\.id))
                let uniqueCoins = newCoins.filter {
                    !existingIDs.contains($0.id)
                }

                currentContent.coins.append(contentsOf: uniqueCoins)
                currentContent.currentPage = nextPage
            }

            currentContent.isPaginating = false
            state = .loaded(currentContent)

        } catch {
            guard case .loaded(var currentContent) = state else { return }
            currentContent.isPaginating = false
            state = .loaded(currentContent)
        }
    }
}
