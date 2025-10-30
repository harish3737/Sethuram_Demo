//
//  CurrencyFormatter.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

enum CurrencyFormatter {
    static func formatINR(_ value: Double) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencySymbol = "₹"
        nf.maximumFractionDigits = 2
        return nf.string(from: NSNumber(value: value)) ?? "₹0.00"
    }
    static func formatSignedINR(_ value: Double) -> String {
        let sign = value >= 0 ? "" : "-"
        return "\(sign)\(formatINR(abs(value)))"
    }
}
