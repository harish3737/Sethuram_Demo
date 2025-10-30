//
//  AppCoordinator.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    init(window: UIWindow) { self.window = window }

    func start() {
        // DI
        let base = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")!
        let http = URLSessionHTTPClient()
        let repo = PortfolioRepositoryImpl(client: http, baseURL: base)
        let compute = ComputePortfolioUseCaseImpl()
        let store = PortfolioStore()

        // Portfolio feature
        let holdingsVM = HoldingsViewModel(repo: repo, compute: compute, store: store)
        let holdingsVC = HoldingsViewController(viewModel: holdingsVM)
        let portfolioNav = RootNavigationController(root: holdingsVC, viewModel: RootNavigationViewModel(title: "Portfolio"))

        // Other features (placeholders initially)
//        let watchlistVC = RootNavigationController(
//            root: PlaceholderViewController(viewModel: PlaceholderViewModel(style: .underConstruction, message: "Track stocks soon.")),
//            viewModel: RootNavigationViewModel(title: "Watchlist")
//        )

        // Dashboard container tabs
        let dashboardVM = DashboardViewModel(portfolio: portfolioNav)
        let dashboardVC = DashboardViewController(viewModel: dashboardVM)

        window.rootViewController = dashboardVC
        window.makeKeyAndVisible()
    }
}
