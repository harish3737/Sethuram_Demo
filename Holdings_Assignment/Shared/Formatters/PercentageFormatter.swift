//
//  PercentageFormatter.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

enum PercentageFormatter {
    static func format(_ pct: Double) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        return "\(nf.string(from: NSNumber(value: pct)) ?? "0")%"
    }
}
