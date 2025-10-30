//
//  ComputePortfolioUseCase.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public protocol ComputePortfolioUseCase {
    func compute(for holdings: [Holding]) -> PortfolioSummary
}

public struct ComputePortfolioUseCaseImpl: ComputePortfolioUseCase {
    public init() {}
    public func compute(for holdings: [Holding]) -> PortfolioSummary {
        let current = holdings.reduce(0.0) { $0 + ($1.ltp * Double($1.quantity)) }
        let invested = holdings.reduce(0.0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        let totalPNL = current - invested
        let todays = holdings.reduce(0.0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
        return .init(currentValue: current, totalInvestment: invested, totalPNL: totalPNL, todaysPNL: todays)
    }
}
