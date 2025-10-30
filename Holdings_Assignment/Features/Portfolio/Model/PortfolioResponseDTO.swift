//
//  PortfolioResponseDTO.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

struct PortfolioResponseDTO: Decodable {
    struct DataEnvelope: Decodable {
        let userHolding: [Item]
    }
    struct Item: Decodable {
        let symbol: String
        let quantity: Int
        let ltp: Double
        let avgPrice: Double
        let close: Double
    }
    let data: DataEnvelope
}

extension PortfolioResponseDTO.Item {
    var model: Holding {
        Holding(
            symbol: symbol,
            quantity: quantity,
            avgPrice: avgPrice,
            close: close,
            ltp: ltp,
            isT1: false
        )
    }
}
