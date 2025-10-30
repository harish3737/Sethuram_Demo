//
//  DashboardViewModel.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

protocol DashboardViewModeling: AnyObject {
    var tabs: [UIViewController] { get }
}

final class DashboardViewModel: DashboardViewModeling {
    let tabs: [UIViewController]

    init(portfolio: UIViewController) {
        let watchlist = PlaceholderViewController(viewModel: PlaceholderViewModel(style: .underConstruction))
        let orders = PlaceholderViewController(viewModel: PlaceholderViewModel(style: .underConstruction))
        let funds = PlaceholderViewController(viewModel: PlaceholderViewModel(style: .underConstruction))
        let invest = PlaceholderViewController(viewModel: PlaceholderViewModel(style: .underConstruction))

        func wrap(_ vc: UIViewController, title: String) -> UIViewController {
            RootNavigationController(root: vc, viewModel: RootNavigationViewModel(title: title))
        }

        tabs = [
            wrap(watchlist, title: "Watchlist"),
            wrap(orders, title: "Orders"),
            portfolio,
            wrap(funds, title: "Funds"),
            wrap(invest, title: "Invest")
        ]
    }
}


