//
//  HoldingsViewModel.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

protocol HoldingsViewModeling: AnyObject {
    var onStateChange: ((HoldingsViewState) -> Void)? { get set }
    func viewDidLoad()
    func toggleSummary()
}

final class HoldingsViewModel: HoldingsViewModeling {
    private let repo: PortfolioRepository
    private let compute: ComputePortfolioUseCase
    private let store: PortfolioStoreing

    var state = HoldingsViewState(
        isLoading: false,
        error: nil,
        isSummaryExpanded: false,
        rows: [],
        summary: nil
    ) { didSet { onStateChange?(state) } }

    var onStateChange: ((HoldingsViewState) -> Void)?

    init(repo: PortfolioRepository, compute: ComputePortfolioUseCase, store: PortfolioStoreing) {
        self.repo = repo
        self.compute = compute
        self.store = store
    }

    func viewDidLoad() {
        Task { await load() }
    }

    func toggleSummary() {
        state.isSummaryExpanded.toggle()
    }

    private func load() async {
        state.isLoading = true
        do {
            let holdings = try await repo.fetchHoldings()
            let summary = compute.compute(for: holdings)
            await store.update(holdings: holdings, summary: summary)
            state = makeState(holdings: holdings, summary: summary, expanded: state.isSummaryExpanded)
        } catch {
            state.isLoading = false
            let errorMessage = (error as NSError).localizedDescription
            state.error = errorMessage
            state.alertItem = AlertItem(
                title: "Error",
                message: errorMessage,
                dismissButtonTitle: "OK"
            )
        }
    }

    private func makeState(holdings: [Holding], summary: PortfolioSummary, expanded: Bool) -> HoldingsViewState {
        let rows = holdings.map { h in
            let pnl = (h.ltp - h.avgPrice) * Double(h.quantity)
            let color: UIColor = pnl >= 0 ? .systemGreen : .systemRed
            return HoldingRowViewData(
                id: h.symbol,
                title: h.isT1 ? "\(h.symbol) T1 Holding" : h.symbol,
                ltpText: "LTP: \(CurrencyFormatter.formatINR(h.ltp))",
                qtyText: "NET QTY: \(h.quantity)",
                pnlText: "P&L: \(CurrencyFormatter.formatSignedINR(pnl))",
                accent: color
            )
        }
        let sv = SummaryViewData(
            title: "Profit & Loss*",
            totalPNLText: CurrencyFormatter.formatSignedINR(summary.totalPNL),
            percentText: "(\(PercentageFormatter.format(summary.percentChange)))",
            currentValueText: CurrencyFormatter.formatINR(summary.currentValue),
            totalInvestmentText: CurrencyFormatter.formatINR(summary.totalInvestment),
            todaysPNLText: CurrencyFormatter.formatSignedINR(summary.todaysPNL)
        )
        return HoldingsViewState(
            isLoading: false,
            error: nil,
            alertItem: nil,
            isSummaryExpanded: expanded,
            rows: rows,
            summary: sv
        )
    }
}

