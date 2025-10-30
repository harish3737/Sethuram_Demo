//
//  AlertItem.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import Foundation

struct AlertItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButtonTitle: String

    static let networkError = AlertItem(
        title: "Network Error",
        message: "Please check your internet connection and try again.",
        dismissButtonTitle: "OK"
    )

    static let dataError = AlertItem(
        title: "Data Error",
        message: "Received invalid data. Please try again later.",
        dismissButtonTitle: "OK"
    )
}
