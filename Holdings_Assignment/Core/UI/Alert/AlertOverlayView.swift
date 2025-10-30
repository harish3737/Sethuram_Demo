//
//  AlertOverlayView.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import UIKit

class AlertOverlayView: UIView {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let dismissButton = UIButton(type: .system)

    var onDismiss: (() -> Void)?

    init(title: String, message: String, dismissButtonTitle: String) {
        super.init(frame: .zero)
        setupUI(title: title, message: message, buttonTitle: dismissButtonTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String, message: String, buttonTitle: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)

        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        dismissButton.setTitle(buttonTitle, for: .normal)
        dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            dismissButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            dismissButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    @objc private func dismissTapped() {
        hide()
        onDismiss?()
    }

    func show(in parentView: UIView) {
        self.alpha = 0
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        // Animate overlay fade in
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
