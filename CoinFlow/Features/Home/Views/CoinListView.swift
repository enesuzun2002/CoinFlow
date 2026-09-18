//
//  CoinListView.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import SwiftUI

@MainActor
struct CoinListView: View {
    @State private var viewModel: CoinViewModel

    init(viewModel: CoinViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    // Explicit dependency injection (e.g. for testing / mocks)
    init(service: CoinServiceProtocol) {
        _viewModel = State(wrappedValue: CoinViewModel(service: service))
    }

    // Default initializer running on @MainActor
    init() {
        let service = CoinService(networkClient: NetworkClient())
        _viewModel = State(wrappedValue: CoinViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .initialLoading:
                    ProgressView()

                case .failed(let message):
                    ContentUnavailableView {
                        Label(
                            "Bir Hata Oluştu",
                            systemImage: "exclamationmark.triangle"
                        )
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Tekrar Dene") {
                            Task { await viewModel.loadInitialCoins() }
                        }
                        .buttonStyle(.borderedProminent)
                    }

                case .loaded(let content):
                    coinList(content: content)
                }
            }
            .navigationTitle("Piyasa")
            .task {
                await viewModel.loadInitialCoins()
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func coinList(content: CoinState.Content) -> some View {
        List {
            ForEach(content.coins) { coin in
                CoinRowView(coin: coin)
                    .task {
                        // Spawn task only on last item and if we aren't in last page
                        if(coin.id == content.coins.last?.id && !content.isLastPage) {
                            await viewModel.fetchNextPageIfNeeded(for: coin)
                        }
                    }
            }

            if content.isPaginating {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshCoins()
        }
    }
}

// MARK: - Previews

#Preview("Loaded") {
    CoinListView(
        viewModel: CoinViewModel(
            service: MockCoinService()
        )
    )
}

#Preview("Initial Loading") {
    CoinListView(
        viewModel: CoinViewModel(
            state: .initialLoading,
            service: MockCoinService()
        )
    )
}

#Preview("Error State") {
    CoinListView(
        viewModel: CoinViewModel(
            state: .failed(message: "İnternet bağlantısı kurulamadı."),
            service: MockCoinService()
        )
    )
}
