//
//  HTTPClient.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public protocol HTTPClient {
     nonisolated func send<Request: Encodable, Response: Decodable>(
        _ endpoint: Endpoint<Request>,
        decode type: Response.Type
    ) async throws -> Response
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601
            return d
        }(),
        encoder: JSONEncoder = {
            let e = JSONEncoder()
            e.dateEncodingStrategy = .iso8601
            return e
        }()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    public nonisolated func send<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        _ endpoint: Endpoint<Request>,
        decode type: Response.Type
    ) async throws -> Response {
        let request: URLRequest = try await MainActor.run { try endpoint.urlRequest(encoder: encoder) }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.transport(URLError(.badServerResponse))
        }
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.server(status: http.statusCode,  data)
        }

        return try await withCheckedThrowingContinuation { cont in
            Task.detached {
                do {
                    let decoded = try self.decoder.decode(Response.self, from: data)
                    cont.resume(returning: decoded)
                } catch {
                    cont.resume(throwing: NetworkError.decoding(error))
                }
            }
        }
    }
}

