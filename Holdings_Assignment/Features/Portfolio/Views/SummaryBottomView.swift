//
//  SummaryBottomView.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class SummaryBottomSheetView: UIView {

    static let collapsedHeight: CGFloat = 52
    static let expandedHeight: CGFloat = 200

    private let expandedStack = UIStackView()
    private let currentValueRow = SummaryValueRow(label: "Current value*")
    private let investedRow = SummaryValueRow(label: "Total investment*")
    private let todayRow = SummaryValueRow(label: "Today's Profit & Loss*")

    private let divider = UIView()

    private let pnlRow = UIStackView()
    private let pnlTitle = UILabel()
    private let pnlValue = UILabel()
    private let pnlPercent = UILabel()
    private let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))

    private(set) var isExpanded = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { nil }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20
        layer.masksToBounds = false

        expandedStack.axis = .vertical
        expandedStack.alignment = .fill
        expandedStack.spacing = 13
        expandedStack.distribution = .fillEqually
        [currentValueRow, investedRow, todayRow].forEach { expandedStack.addArrangedSubview($0) }
        expandedStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(expandedStack)

        divider.backgroundColor = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)

        pnlTitle.font = .systemFont(ofSize: 15, weight: .medium)
        pnlValue.font = .systemFont(ofSize: 18, weight: .bold)
        pnlPercent.font = .systemFont(ofSize: 13)
        pnlPercent.textColor = .secondaryLabel
        pnlValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        pnlPercent.setContentHuggingPriority(.required, for: .horizontal)
        chevron.tintColor = .tertiaryLabel

        let pnlRightStack = UIStackView(arrangedSubviews: [pnlValue, pnlPercent])
        pnlRightStack.axis = .horizontal
        pnlRightStack.spacing = 7
        pnlRightStack.alignment = .center

        pnlRow.axis = .horizontal
        pnlRow.alignment = .center
        pnlRow.distribution = .fill
        pnlRow.spacing = 8
        pnlRow.translatesAutoresizingMaskIntoConstraints = false

        pnlRow.addArrangedSubview(pnlTitle)
        pnlRow.addArrangedSubview(UIView())
        pnlRow.addArrangedSubview(pnlRightStack)
        pnlRow.addArrangedSubview(chevron)
        addSubview(pnlRow)

        NSLayoutConstraint.activate([
            expandedStack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            expandedStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            expandedStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: expandedStack.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),

            pnlRow.topAnchor.constraint(equalTo: divider.bottomAnchor),
            pnlRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pnlRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pnlRow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            pnlRow.heightAnchor.constraint(equalToConstant: 32)
        ])
        setExpanded(false, animated: false)
    }

    func configure(summary: SummaryViewData, expanded: Bool) {
        currentValueRow.set(value: summary.currentValueText)
        investedRow.set(value: summary.totalInvestmentText)
        todayRow.set(value: summary.todaysPNLText, valueColor: colorForValue(summary.todaysPNLText))
        pnlTitle.text = summary.title
        pnlValue.text = summary.totalPNLText
        pnlValue.textColor = colorForValue(summary.totalPNLText)
        pnlPercent.text = summary.percentText
        setExpanded(expanded, animated: true)
    }

    func setExpanded(_ expanded: Bool, animated: Bool) {
        isExpanded = expanded
        expandedStack.isHidden = !expanded
        divider.isHidden = !expanded
        let angle: CGFloat = expanded ? .pi : 0
        let turnChevron = { self.chevron.transform = CGAffineTransform(rotationAngle: angle) }
        UIView.animate(withDuration: 0.22) { turnChevron() }
        setNeedsLayout()
    }

    private func colorForValue(_ string: String) -> UIColor {
        // Use numeric logic if needed
        if string.contains("-") {
            return .systemRed
        }
        return .systemGreen
    }
}

final class SummaryValueRow: UIView {
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()

    init(label: String) {
        super.init(frame: .zero)
        leftLabel.text = label // Static text: e.g., "Current value*"
        leftLabel.font = .systemFont(ofSize: 15, weight: .regular)
        leftLabel.textColor = .label
        rightLabel.font = .systemFont(ofSize: 15, weight: .bold)
        rightLabel.textColor = .label
        rightLabel.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [leftLabel, UIView(), rightLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func set(value: String, valueColor: UIColor? = nil) {
        rightLabel.text = value
        rightLabel.textColor = valueColor ?? .label
    }
}

