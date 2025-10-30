//
//  RootTabBarController.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class RootTabBarController: UITabBarController {
    private let vm: RootTabBarViewModeling
    init(viewModel: RootTabBarViewModeling, controllers: [UIViewController]) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
        for (i, vc) in controllers.enumerated() where i < vm.items.count {
            vc.tabBarItem = vm.items[i]
        }
        viewControllers = controllers
    }
    required init?(coder: NSCoder) { nil }
}
