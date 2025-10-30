//
//  PlaceholderViewModel.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

protocol PlaceholderViewModeling: AnyObject {
    var title: String { get }
    var message: String? { get }
    var icon: UIImage? { get }
    var tint: UIColor { get }
}

final class PlaceholderViewModel: PlaceholderViewModeling {
    let title: String
    let message: String?
    let icon: UIImage?
    let tint: UIColor

    init(style: PlaceholderStyle, message: String? = nil) {
        self.title = style.title
        switch style {
        case .underConstruction:
            self.message = message ?? "This section will be available soon."
        case .error(let msg):
            self.message = msg
        }
        self.icon = UIImage(systemName: style.iconName)
        self.tint = style.tint
    }
}
