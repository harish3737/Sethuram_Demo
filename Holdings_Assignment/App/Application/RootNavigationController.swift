//
//  RootNavigationController.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class RootNavigationController: UINavigationController {
    private let vm: RootNavigationViewModeling
    init(root: UIViewController, viewModel: RootNavigationViewModeling) {
        self.vm = viewModel
        super.init(rootViewController: root)
        root.navigationItem.title = vm.title
    }
    required init?(coder: NSCoder) { nil }
}
