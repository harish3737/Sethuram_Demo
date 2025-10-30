//
//  HoldingsViewController.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import UIKit

final class HoldingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let viewModel: HoldingsViewModeling

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let segmented = UISegmentedControl(items: ["POSITIONS", "HOLDINGS"])
    private var rows: [HoldingRowViewData] = []

    // Bottom summary sheet
    private let summarySheet = SummaryBottomSheetView()
    private var summarySheetBottom: NSLayoutConstraint!
    private var summarySheetHeight: NSLayoutConstraint!
    private var expanded = false
    private var noContentView: UIView!
    private var isAlertPresented = false

    init(viewModel: HoldingsViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Portfolio"
        setupSegmented()
        setupTable()
        setupSummarySheet()
        bind()
        viewModel.viewDidLoad()
        noContentView = createNoContentView()
        self.view.addSubview(noContentView)

    }
    

    private func setupSegmented() {
        segmented.selectedSegmentIndex = 1
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        view.addSubview(segmented)
        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.reuseID)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.contentInset.bottom = SummaryBottomSheetView.expandedHeight + 10
    }

    private func setupSummarySheet() {
        view.addSubview(summarySheet)
        summarySheet.translatesAutoresizingMaskIntoConstraints = false
        summarySheetBottom = summarySheet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        summarySheetHeight = summarySheet.heightAnchor.constraint(equalToConstant: SummaryBottomSheetView.collapsedHeight)
        NSLayoutConstraint.activate([
            summarySheet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            summarySheet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            summarySheetBottom,
            summarySheetHeight
        ])
        summarySheet.layer.shadowColor = UIColor.black.cgColor
        summarySheet.layer.shadowOpacity = 0.1
        summarySheet.layer.shadowOffset = CGSize(width: 0, height: -2)
        summarySheet.layer.shadowRadius = 12
        let tap = UITapGestureRecognizer(target: self, action: #selector(summaryTapped))
        summarySheet.addGestureRecognizer(tap)
        summarySheet.isUserInteractionEnabled = true
    }
    
    private func createNoContentView() -> UIView {
        let noContentView = UIView()
        noContentView.backgroundColor = .systemBackground
        noContentView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "No Content Available"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false

        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton
            .addTarget(
                self,
                action: #selector(retryTapped),
                for: .touchUpInside
            )

        noContentView.addSubview(label)
        noContentView.addSubview(retryButton)

        // Ensure the noContentView is added to the view hierarchy **before** activating its constraints
        view.addSubview(noContentView)
        NSLayoutConstraint.activate([
            noContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noContentView.topAnchor.constraint(equalTo: view.topAnchor),
            noContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            label.centerXAnchor.constraint(equalTo: noContentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: noContentView.centerYAnchor, constant: -20),

            retryButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: noContentView.centerXAnchor)
        ])

        noContentView.isHidden = true
        return noContentView
    }
    
    func toggleNoContentView(_ show: Bool) {
        noContentView.isHidden = !show
        if show {
            view.bringSubviewToFront(noContentView)
        }
    }

    
    @objc private func retryTapped() {
        viewModel.viewDidLoad()
    }

    @objc private func summaryTapped() {
        setSummaryExpanded(!expanded, animated: true)
    }

    private func setSummaryExpanded(_ isExpanded: Bool, animated: Bool) {
        expanded = isExpanded
        summarySheet.setExpanded(isExpanded, animated: animated)
        summarySheetHeight.constant = isExpanded ? SummaryBottomSheetView.expandedHeight : SummaryBottomSheetView.collapsedHeight
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.7,
            options: [.curveEaseInOut]
        ) { self.view.layoutIfNeeded() }
    }

    @objc private func segmentedChanged() {
        if segmented.selectedSegmentIndex == 0 {
            // Display under construction modal
            let vm = PlaceholderViewModel(style: .underConstruction, message: "Positions view will be available soon.")
            let vc = PlaceholderViewController(viewModel: vm)
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            present(vc, animated: true)
            segmented.selectedSegmentIndex = 1 
        }
    }

    private func bind() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            state.isLoading ? LoaderOverlayView.shared.show() : LoaderOverlayView.shared.hide()
            self.rows = state.rows
            self.tableView.reloadData()
            self.toggleNoContentView(state.rows.isEmpty)
            if state.error != nil {
                DispatchQueue.main.async {
                    if let alert = state.alertItem {
                        self.showAlert(alert)
                    }
                }
            }
     
            if let summary = state.summary {
                self.summarySheet.configure(summary: summary, expanded: self.expanded)
            }
        }
    }
    
    func showAlert(_ alert: AlertItem) {
        // Show the alert only if one isn't already being shown
        guard !isAlertPresented else { return }

        isAlertPresented = true

        let alertView = AlertOverlayView(
            title: alert.title,
            message: alert.message,
            dismissButtonTitle: alert.dismissButtonTitle
        )

        alertView.onDismiss = { [weak self] in
            self?.isAlertPresented = false
            self?.toggleNoContentView(self?.rows.isEmpty ?? true)
        }

        alertView.show(in: view)
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.reuseID, for: indexPath) as! HoldingCell
        cell.configure(vm)
        return cell
    }
}


