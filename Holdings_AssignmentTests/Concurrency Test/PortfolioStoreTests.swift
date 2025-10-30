//
//  PortfolioStoreTests.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import XCTest
@testable import Holdings_Assignment

@MainActor
final class PortfolioStoreTests: XCTestCase {
    
    var portfolioStore: PortfolioStore!
    
    override func setUp() async throws {
        portfolioStore = PortfolioStore()
    }
    
    override func tearDown() async throws {
        portfolioStore = nil
    }
    
    func testUpdateAndReadHoldings() async throws {
        let holdings = [
            Holding(symbol: "AAPL", quantity: 10, avgPrice: 100, close: 150, ltp: 155, isT1: false)
        ]
        
        let summary = PortfolioSummary(
            currentValue: 1550,
            totalInvestment: 1000,
            totalPNL: 550,
            todaysPNL: 100
        )
        
        await portfolioStore.update(holdings: holdings, summary: summary)
        
        let storedHoldings = await portfolioStore.holdings
        let storedSummary = await portfolioStore.summary
        
        XCTAssertEqual(storedHoldings.count, holdings.count)
        XCTAssertEqual(storedHoldings.first?.symbol, "AAPL")
        
        XCTAssertEqual(storedSummary?.currentValue, summary.currentValue)
        XCTAssertEqual(storedSummary?.percentChange, summary.percentChange)
    }
    
    func testConcurrencySafety() async throws {
        let holdings1 = [
            Holding(symbol: "AAPL", quantity: 10, avgPrice: 100, close: 150, ltp: 155, isT1: false)
        ]
        let holdings2 = [
            Holding(symbol: "MSFT", quantity: 5, avgPrice: 200, close: 220, ltp: 225, isT1: true)
        ]
        
        let summary1 = PortfolioSummary(
            currentValue: 1550,
            totalInvestment: 1000,
            totalPNL: 550,
            todaysPNL: 100
        )
        let summary2 = PortfolioSummary(
            currentValue: 1100,
            totalInvestment: 1050,
            totalPNL: 50,
            todaysPNL: 50
        )
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.portfolioStore.update(holdings: holdings1, summary: summary1) }
            group.addTask { await self.portfolioStore.update(holdings: holdings2, summary: summary2) }
        }
        
        let finalHoldings = await portfolioStore.holdings
        XCTAssertTrue(finalHoldings == holdings1 || finalHoldings == holdings2)
    }
}
