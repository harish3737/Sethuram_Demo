//
//  Holding.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public struct Holding: Equatable, Hashable {
    public let symbol: String
    public let quantity: Int
    public let avgPrice: Double
    public let close: Double
    public let ltp: Double
    public let isT1: Bool

    public init(symbol: String, quantity: Int, avgPrice: Double, close: Double, ltp: Double, isT1: Bool = false) {
        self.symbol = symbol
        self.quantity = quantity
        self.avgPrice = avgPrice
        self.close = close
        self.ltp = ltp
        self.isT1 = isT1
    }
}
