//
//  LoadingIndicatorView.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

class LoaderOverlayView: UIView {
    static let shared = LoaderOverlayView()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        setupIndicator()
    }

    required init?(coder: NSCoder) { fatalError("Use shared instance") }

    private func setupIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func show() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
            else { return }

            if self.superview == nil {
                keyWindow.addSubview(self)

                NSLayoutConstraint.activate([
                    self.topAnchor.constraint(equalTo: keyWindow.topAnchor),
                    self.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
                    self.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                    self.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor)
                ])
            }
            self.isHidden = false
            self.activityIndicator.startAnimating()
            self.isUserInteractionEnabled = true
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
}


