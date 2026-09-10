//
//  NetworkError.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//

import Foundation

/// Represents transport-level networking, connectivity, and HTTP decoding errors.
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingFailed(underlyingError: Error)
    case transportError(underlyingError: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL is invalid."
        case .invalidResponse:
            return "Received an unexpected or non-HTTP response."
        case .httpError(let code, _):
            return "Server returned HTTP status \(code)."
        case .decodingFailed(let error):
            return "Failed to parse response payload: \(error.localizedDescription)"
        case .transportError(let error):
            return "Network connection failed: \(error.localizedDescription)"
        }
    }
}
