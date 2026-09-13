//
//  NetworkClient.swift
//  CoinFlow
//
//  Created by Enes Murat Uzun on 10.09.2026.
//


import Foundation

protocol NetworkClientProtocol: Sendable {
    func execute<T: Decodable>(endpoint: Endpoint) async throws -> T
}

/// Handles generic HTTP request execution and response decoding.
final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return decoder
        }()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func execute<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let request = try endpoint.asURLRequest()

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transportError(underlyingError: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlyingError: error)
        }
    }
}
