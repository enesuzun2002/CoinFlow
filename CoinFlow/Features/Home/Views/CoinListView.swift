//
//  CoinListView.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation
import SwiftUI

struct CoinListView: View {
    @State private var viewModel = CoinViewModel(
        state: CoinState(coins: [], isLoading: false),
        service: CoinService(networkClient: NetworkClient())
    )
    
    var body: some View {
        ZStack {
            if viewModel.state.isLoading && viewModel.state.coins.isEmpty {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.state.coins) { coin in
                        Text(coin.name)
                            .onAppear {
                                Task {
                                    await viewModel.fetchNextPageIfNeeded(for: coin)
                                }
                            }
                    }

                    // Inline bottom spinner while loading subsequent pages
                    if viewModel.state.isLoading && !viewModel.state.coins.isEmpty {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchCoins()
        }
    }
}
