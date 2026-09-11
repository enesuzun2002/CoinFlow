//
//  CoinGeckoEndpoint.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

enum CoinGeckoEndpoint: Endpoint {
    case markets(page: Int, perPage: Int = 10)
    
    // API Host
    var host: String {
        "api.coingecko.com"
    }
    
    // Base path to include in path
    private var basePath: String {
        return "/api/v3"
    }
    
    // Path
    var path: String {
        switch self {
        case .markets:
            return basePath + "/coins/markets"
        }
    }
    
    // HTTP Method to be used
    var method: HTTPMethod  {
        switch self {
        case .markets:
            return .get
        }
    }
    
    // Headers
    var headers: [String : String]? {
        return ["x-cg-demo-api-key": APIConfig.coinGeckoKey]
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .markets(page, perPage):
            return [URLQueryItem(name: "vs_currency", value: "usd"),
                    URLQueryItem(name: "per_page", value: String(perPage)),
                    URLQueryItem(name: "page", value: String(page))]
        }
    }
    
}
