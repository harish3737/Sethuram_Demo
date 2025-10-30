//
//  PortfolioRepository.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public protocol PortfolioRepository {
    func fetchHoldings() async throws -> [Holding]
}
