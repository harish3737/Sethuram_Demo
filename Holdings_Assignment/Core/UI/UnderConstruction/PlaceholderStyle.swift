//
//  PlaceholderStyle.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//
import UIKit

enum PlaceholderStyle {
    case underConstruction
    case error(message: String)

    var iconName: String {
        switch self {
        case .underConstruction: return "hammer.circle"
        case .error: return "exclamationmark.triangle"
        }
    }
    var title: String {
        switch self {
        case .underConstruction: return "View under construction"
        case .error: return "Something went wrong"
        }
    }
    var tint: UIColor {
        switch self {
        case .underConstruction: return .tertiaryLabel
        case .error: return .systemOrange
        }
    }
}
