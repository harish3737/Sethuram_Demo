//
//  RootTabBarViewModel.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation
import UIKit

protocol RootTabBarViewModeling: AnyObject {
    var items: [UITabBarItem] { get }
}

final class RootTabBarViewModel: RootTabBarViewModeling {
    let items: [UITabBarItem]
    init() {
        items = [
            UITabBarItem(title: "Watchlist", image: UIImage(systemName: "eye"), tag: 0),
            UITabBarItem(title: "Orders", image: UIImage(systemName: "doc"), tag: 1),
            UITabBarItem(title: "Portfolio", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), tag: 2),
            UITabBarItem(title: "Funds", image: UIImage(systemName: "indianrupeesign.circle"), tag: 3),
            UITabBarItem(title: "Invest", image: UIImage(systemName: "sparkles"), tag: 4)
        ]
    }
}
