//
//  PortfolioRepositoryImpl.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public final class PortfolioRepositoryImpl: PortfolioRepository {
    private let client: HTTPClient
    private let base: URL

    public init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.base = baseURL
    }

    public func fetchHoldings() async throws -> [Holding] {
        guard ReachabilityManager.shared.isConnected else {
            throw NetworkError.notConnected
        }
        let ep = Endpoint<VoidBody>(baseURL: base)
        let dto = try await client.send(ep, decode: PortfolioResponseDTO.self)
        let envelope = dto.data
        let holdingsDTOs = envelope.userHolding
        return holdingsDTOs.map { $0.model }
    }
}

