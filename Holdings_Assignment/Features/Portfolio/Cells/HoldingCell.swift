//
//  HoldingCell.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class HoldingCell: UITableViewCell {
    static let reuseID = "HoldingCell"
    private let titleLabel = UILabel()
    private let ltpLabel = UILabel()
    private let qtyLabel = UILabel()
    private let pnlLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    required init?(coder: NSCoder) { nil }

    private func setup() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ltpLabel.font = .systemFont(ofSize: 13)
        qtyLabel.font = .systemFont(ofSize: 13)
        pnlLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        titleLabel.textColor = .label
        ltpLabel.textColor = .label
        qtyLabel.textColor = .label
        pnlLabel.textColor = .label
        

        let left = UIStackView(arrangedSubviews: [titleLabel, ltpLabel])
        left.axis = .vertical
        left.spacing = 4

        let right = UIStackView(arrangedSubviews: [qtyLabel, pnlLabel])
        right.axis = .vertical
        right.alignment = .trailing
        right.spacing = 4

        let row = UIStackView(arrangedSubviews: [left, UIView(), right])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(_ vm: HoldingRowViewData) {
        titleLabel.text = vm.title
        ltpLabel.text = vm.ltpText
        qtyLabel.text = vm.qtyText
        pnlLabel.text = vm.pnlText
        pnlLabel.textColor = vm.accent
    }
}
