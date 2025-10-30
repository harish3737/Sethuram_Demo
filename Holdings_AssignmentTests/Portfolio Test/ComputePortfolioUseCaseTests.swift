//
//  ComputePortfolioUseCaseTests.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//
import XCTest
@testable import Holdings_Assignment

@MainActor
final class ComputePortfolioUseCaseTests: XCTestCase {

    var useCase: ComputePortfolioUseCase!

    override func setUp() {
        super.setUp()
        useCase = ComputePortfolioUseCaseImpl()
    }

    override func tearDown() {
        useCase = nil
        super.tearDown()
    }

    func testComputePortfolioWithValidHoldings() {
        let holdings = [
            Holding(symbol: "AAPL", quantity: 10, avgPrice: 100, close: 150, ltp: 155, isT1: false),
            Holding(symbol: "MSFT", quantity: 5, avgPrice: 200, close: 220, ltp: 225, isT1: true)
        ]

        let summary = useCase.compute(for: holdings)

        let expectedTotalInvestment = 10 * 100 + 5 * 200
        let expectedCurrentValue = 10 * 155 + 5 * 225
        let expectedTodaysPNL = 10 * (150 - 155) + 5 * (220 - 225)
        let expectedTotalPNL = 10 * (155 - 100) + 5 * (225 - 200)
        let expectedPercentChange = ((Double(expectedCurrentValue) / Double(expectedTotalInvestment)) - 1) * 100

        XCTAssertEqual(summary.totalInvestment, Double(expectedTotalInvestment), accuracy: 0.0001)
        XCTAssertEqual(summary.currentValue, Double(expectedCurrentValue), accuracy: 0.0001)
        XCTAssertEqual(summary.todaysPNL, Double(expectedTodaysPNL), accuracy: 0.0001)
        XCTAssertEqual(summary.totalPNL, Double(expectedTotalPNL), accuracy: 0.0001)
        XCTAssertEqual(summary.percentChange, expectedPercentChange, accuracy: 0.0001)
    }

    func testComputePortfolioWithEmptyHoldings() {
        let holdings: [Holding] = []

        let summary = useCase.compute(for: holdings)

        XCTAssertEqual(summary.totalInvestment, 0)
        XCTAssertEqual(summary.currentValue, 0)
        XCTAssertEqual(summary.todaysPNL, 0)
        XCTAssertEqual(summary.totalPNL, 0)
        XCTAssertEqual(summary.percentChange, 0)
    }

    func testComputePortfolioWithNegativeValues() {
        let holdings = [
            Holding(symbol: "AAPL", quantity: -10, avgPrice: -100, close: -150, ltp: -155, isT1: false)
        ]

        let summary = useCase.compute(for: holdings)

        let expectedTotalInvestment = (-10) * (-100)
        let expectedCurrentValue = (-10) * (-155)
        let expectedTodaysPNL = (-10) * (-150 - -155)
        let expectedTotalPNL = (-10) * (-155 - -100)
        let expectedPercentChange = ((Double(expectedCurrentValue) / Double(expectedTotalInvestment)) - 1) * 100

        XCTAssertEqual(summary.totalInvestment, Double(expectedTotalInvestment), accuracy: 0.0001)
        XCTAssertEqual(summary.currentValue, Double(expectedCurrentValue), accuracy: 0.0001)
        XCTAssertEqual(summary.todaysPNL, Double(expectedTodaysPNL), accuracy: 0.0001)
        XCTAssertEqual(summary.totalPNL, Double(expectedTotalPNL), accuracy: 0.0001)
        XCTAssertEqual(summary.percentChange, expectedPercentChange, accuracy: 0.0001)
    }

}


