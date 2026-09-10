//
//  APIConfig.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation


enum APIConfig {
    static var coinGeckoKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "CoinGeckoAPIKey") as? String, 
              !key.isEmpty, 
              key != "your_actual_api_key_here" else {
            fatalError("CoinGecko API key is missing or not configured in Secrets.xcconfig.")
        }
        return key
    }
}
