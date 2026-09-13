//
//  CoinListView.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation
import SwiftUI

@MainActor
struct CoinListView: View {
    // 1. Durumu bu ekran yönetir
    @State private var viewModel: CoinViewModel

    // 2. Mock / Test enjeksiyonu için
    init(viewModel: CoinViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    // 3. Canlı uygulama için (Parametresiz varsayılan)
    init() {
        self.init(viewModel: CoinViewModel(service: CoinService(networkClient: NetworkClient())))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.state.isLoading && viewModel.state.coins.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.state.coins) { coin in
                            CoinRowView(coin: coin)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchNextPageIfNeeded(for: coin)
                                    }
                                }
                        }

                        if viewModel.state.isLoading && !viewModel.state.coins.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable{
                        await viewModel.refreshCoins()
                    }
                }
            }
            .navigationTitle("Piyasa")
            .task {
                if viewModel.state.coins.isEmpty {
                    await viewModel.fetchCoins()
                }
            }
        }
    }
}

// MARK: - Previews
#Preview("Mock Servis") {
    CoinListView(
        viewModel: CoinViewModel(service: MockCoinService())
    )
}
