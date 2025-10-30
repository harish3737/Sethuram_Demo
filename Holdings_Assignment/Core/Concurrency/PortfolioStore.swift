//
//  PortfolioStore.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//
import Foundation

protocol PortfolioStoreing {
    func update(holdings: [Holding], summary: PortfolioSummary) async
}

public actor PortfolioStore : PortfolioStoreing {
    public private(set) var holdings: [Holding] = []
    public private(set) var summary: PortfolioSummary?

    public init() {}

    func update(holdings: [Holding], summary: PortfolioSummary) async {
        self.holdings = holdings
        self.summary = summary
    }
}

