//
//  MockHTTPClient .swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import XCTest
@testable import Holdings_Assignment

@MainActor
final class HoldingsViewModelTests: XCTestCase {
    
    var viewModel: HoldingsViewModel!
    var mockRepo: MockPortfolioRepository!
    var mockCompute: MockComputePortfolioUseCase!
    var mockStore: MockPortfolioStore!
    
    override func setUp() async throws {
        mockRepo = MockPortfolioRepository()
        mockCompute = MockComputePortfolioUseCase()
        mockStore = MockPortfolioStore()
        
        viewModel = await MainActor.run {
            HoldingsViewModel(repo: mockRepo, compute: mockCompute, store: mockStore)
        }
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockRepo = nil
        mockCompute = nil
        mockStore = nil
    }
    
    
    func testLoadHoldingsSuccess() async {
        let holding = await makeTestHolding()
        mockRepo.mockHoldings = [holding]
        mockCompute.mockSummary = PortfolioSummary(
            currentValue: 1550,
            totalInvestment: 1000,
            totalPNL: 550,
            todaysPNL: 100
        )
        
        let expectation = expectation(description: "State updated successfully")
        viewModel.onStateChange = { state in
            if !state.isLoading { expectation.fulfill() }
        }
        
        viewModel.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual(viewModel.state.rows.count, 1)
        XCTAssertEqual(viewModel.state.rows.first?.id, holding.symbol)
        XCTAssertEqual(viewModel.state.summary?.totalPNLText, CurrencyFormatter.formatSignedINR(550))
        XCTAssertEqual(viewModel.state.summary?.percentText, "(55%)")
        
        let updateCount = await mockStore.updateCallCount
        XCTAssertEqual(updateCount, 1)
    }
    
    func testLoadHoldingsEmpty() async {
        mockRepo.mockHoldings = []
        mockCompute.mockSummary = PortfolioSummary(
            currentValue: 0,
            totalInvestment: 0,
            totalPNL: 0,
            todaysPNL: 0
        )
        
        let expectation = expectation(description: "State updated to empty")
        viewModel.onStateChange = { state in
            if !state.isLoading { expectation.fulfill() }
        }
        
        viewModel.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual(viewModel.state.rows.count, 0)
        XCTAssertEqual(viewModel.state.summary?.totalPNLText, CurrencyFormatter.formatSignedINR(0))
        
        let updateCount = await mockStore.updateCallCount
        XCTAssertEqual(updateCount, 1)
    }
    
    func testLoadHoldingsFailure() async throws {
        mockRepo.shouldThrowError = true
        
        let expectation = expectation(description: "Error state shown")
        
        var isFulfilled = false
        viewModel.onStateChange = { state in
            if !state.isLoading && !isFulfilled {
                isFulfilled = true
                expectation.fulfill()
            }
        }
        
        viewModel.viewDidLoad()  // synchronous call
        
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertEqual(viewModel.state.rows.count, 0)
        XCTAssertNil(viewModel.state.summary)
        
        let updateCount = await mockStore.updateCallCount
        XCTAssertEqual(updateCount, 0)
    }
    
    
    func testRefreshHoldingsReloadsData() async {
        let holding = await makeTestHolding()
        mockRepo.mockHoldings = [holding]
        mockCompute.mockSummary = PortfolioSummary(
            currentValue: 1550,
            totalInvestment: 1000,
            totalPNL: 550,
            todaysPNL: 100
        )
        
        let expectation = expectation(description: "State loaded with data")
        var isFulfilled = false
        
        viewModel.onStateChange = { state in
            if !state.isLoading && !isFulfilled {
                isFulfilled = true
                expectation.fulfill()
            }
        }
        
        viewModel.viewDidLoad()
        
        // Use await fulfillment instead of waitForExpectations
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertEqual(viewModel.state.rows.count, 1)
    }
    
    func testSummaryFormatting() async {
        let holding = await makeTestHolding()
        mockRepo.mockHoldings = [holding]
        mockCompute.mockSummary = PortfolioSummary(
            currentValue: 555.55,
            totalInvestment: 500.00,
            totalPNL: 55.55,
            todaysPNL: 10.10
        )
        
        let expectation = expectation(description: "State summary updated")
        
        var fulfilled = false
        viewModel.onStateChange = { state in
            if state.summary != nil && !fulfilled {
                fulfilled = true
                expectation.fulfill()
            }
        }
        
        viewModel.viewDidLoad()
        
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.state.summary?.totalPNLText, CurrencyFormatter.formatSignedINR(55.55))
        XCTAssertEqual(viewModel.state.summary?.percentText, "(11.11%)")
    }
}
