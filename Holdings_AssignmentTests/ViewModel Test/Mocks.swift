//
//  Mocks.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import XCTest
@testable import Holdings_Assignment

actor MockPortfolioStore: PortfolioStoreing {
    var updateCallCount = 0
    func update(holdings: [Holding], summary: PortfolioSummary) async {
        updateCallCount += 1
    }
}

class MockPortfolioRepository: PortfolioRepository {
    var mockHoldings: [Holding] = []
    var shouldThrowError = false
    
    func fetchHoldings() async throws -> [Holding] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockHoldings
    }
}


class MockComputePortfolioUseCase: ComputePortfolioUseCase {
    var mockSummary: PortfolioSummary!
    
    func compute(for holdings: [Holding]) -> PortfolioSummary {
        return mockSummary
    }
}


func makeTestHolding() async -> Holding {
    await MainActor.run {
        Holding(symbol: "AAPL", quantity: 10, avgPrice: 100, close: 150, ltp: 155, isT1: false)
    }
}

// MARK: - Helper AsyncStream to observe ViewModel state changes

func createStateStream(viewModel: HoldingsViewModel) -> AsyncStream<HoldingsViewState> {
    AsyncStream { continuation in
        viewModel.onStateChange = { state in
            continuation.yield(state)
            if !state.isLoading { // we consider loading finished when !isLoading
                continuation.finish()
            }
        }
    }
}
