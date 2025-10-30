//
//  RootNavigationViewModel.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

protocol RootNavigationViewModeling: AnyObject {
    var title: String { get }
}

final class RootNavigationViewModel: RootNavigationViewModeling {
    let title: String
    init(title: String) { self.title = title }
}
