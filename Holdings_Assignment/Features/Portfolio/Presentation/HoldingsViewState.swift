//
//  HoldingsViewState.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

struct HoldingsViewState: Equatable {
    var isLoading: Bool
    var error: String?
    var alertItem: AlertItem?
    var isSummaryExpanded: Bool
    var rows: [HoldingRowViewData]
    var summary: SummaryViewData?
}

struct HoldingRowViewData: Hashable {
    let id: String
    let title: String
    let ltpText: String
    let qtyText: String
    let pnlText: String
    let accent: UIColor
}

struct SummaryViewData: Equatable {
    let title: String
    let totalPNLText: String
    let percentText: String
    let currentValueText: String
    let totalInvestmentText: String
    let todaysPNLText: String
}

