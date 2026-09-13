//
//  CoinGeckoError.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 11.09.2026.
//


import Foundation

enum CoinGeckoError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case forbidden
    case timeout
    case rateLimitExceeded
    case internalServerError
    case serviceUnavailable
    case accessDenied
    case serverError(statusCode: Int)
    case networkFailure(underlying: NetworkError)
    case unexpected(Error)

    init(from networkError: NetworkError) {
        switch networkError {
        case .httpError(let statusCode, _):

            switch statusCode {
            case 400:
                self = .badRequest
            case 401:
                self = .unauthorized
            case 403:
                self = .forbidden
            case 408:
                self = .timeout
            case 429:
                self = .rateLimitExceeded
            case 500:
                self = .internalServerError
            case 503:
                self = .serviceUnavailable
            case 1020:
                self = .accessDenied
            default:
                self = .serverError(statusCode: statusCode)
            }

        default:
            self = .networkFailure(underlying: networkError)
        }
    }

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Invalid request — check your parameters."
        case .unauthorized:
            return "Missing or invalid API key."
        case .forbidden:
            return "Access blocked by the server."
        case .timeout:
            return "Request took too long — usually caused by slow network on your end."
        case .rateLimitExceeded:
            return "Rate limit exceeded. Reduce call frequency or upgrade your plan."
        case .internalServerError:
            return "Unexpected server error."
        case .serviceUnavailable:
            return "Service unavailable. Check status.coingecko.com for outages."
        case .accessDenied:
            return "Blocked by CDN firewall rule."
        case .serverError(let code):
            return "CoinGecko returned HTTP status \(code)."
        case .networkFailure(let underlying):
            return underlying.localizedDescription
        case .unexpected(let error):
            return error.localizedDescription
        }
    }
}
