//
//  PortfolioSummary.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//
import Foundation

public struct PortfolioSummary: Equatable {
    public let currentValue: Double
    public let totalInvestment: Double
    public let totalPNL: Double
    public let todaysPNL: Double

    public init(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        self.currentValue = currentValue
        self.totalInvestment = totalInvestment
        self.totalPNL = totalPNL
        self.todaysPNL = todaysPNL
    }

    public var percentChange: Double {
        guard totalInvestment != 0 else { return 0 }
        return (totalPNL / totalInvestment) * 100
    }
}

