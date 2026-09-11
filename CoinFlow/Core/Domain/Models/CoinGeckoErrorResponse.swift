//
//  CoinGeckoErrorResponse.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//

import Foundation

struct CoinGeckoErrorResponse: Decodable {
    struct Status: Decodable {
        let errorCode: Int?
        let errorMessage: String?
    }
    
    let status: Status?
    let error: String?
}
