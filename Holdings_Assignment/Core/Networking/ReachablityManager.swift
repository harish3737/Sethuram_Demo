//
//  ReachablityManager.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 30/10/25.
//

import Network


final class ReachabilityManager {
    static let shared = ReachabilityManager()
    private let monitor: NWPathMonitor
    private var isMonitoring = false

    private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        guard !isMonitoring else { return }
        let queue = DispatchQueue(label: "ReachabilityMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
        isMonitoring = true
    }

    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
}
