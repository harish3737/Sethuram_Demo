//
//  PortfolioRepositoryTests.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import XCTest
import Foundation
@testable import Holdings_Assignment

class MockHTTPClient: HTTPClient {
    var mockResult: Result<PortfolioResponseDTO, Error>?

    func send<Request, Response>(
      _ endpoint: Endpoint<Request>,
      decode type: Response.Type
    ) async throws -> Response where Request : Encodable, Response : Decodable {
        guard let result = mockResult else {
            fatalError("mockResult not set")
        }
        switch result {
        case .success(let value):
            if let castedValue = value as? Response {
                return castedValue
            } else {
                throw NSError(domain: "MockHTTPClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Type mismatch in mockResult"])
            }
        case .failure(let error):
            throw error
        }
    }
}

@MainActor
final class PortfolioRepositoryTests: XCTestCase {

    var repository: PortfolioRepositoryImpl!
    var mockHTTPClient: MockHTTPClient!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        repository = PortfolioRepositoryImpl(client: mockHTTPClient, baseURL: URL(string: "https://mock.api")!)
    }

    override func tearDown() {
        repository = nil
        mockHTTPClient = nil
        super.tearDown()
    }

    func testFetchHoldingsSuccess() async throws {
        let mockItem = PortfolioResponseDTO.Item(
            symbol: "AAPL",
            quantity: 10,
            ltp: 155,
            avgPrice: 100,
            close: 150
        )

        let mockEnvelope = PortfolioResponseDTO.DataEnvelope(userHolding: [mockItem])
        let mockResponse = PortfolioResponseDTO( data: mockEnvelope)

        mockHTTPClient.mockResult = .success(mockResponse)

        let holdings = try await repository.fetchHoldings()

        XCTAssertEqual(holdings.count, 1)
        XCTAssertEqual(holdings.first?.symbol, "AAPL")
        XCTAssertEqual(holdings.first?.quantity, 10)
        XCTAssertEqual(holdings.first?.ltp, 155)
    }

    func testFetchHoldingsFailure() async throws {
        mockHTTPClient.mockResult = .failure(URLError(.notConnectedToInternet))

        do {
            _ = try await repository.fetchHoldings()
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
}



