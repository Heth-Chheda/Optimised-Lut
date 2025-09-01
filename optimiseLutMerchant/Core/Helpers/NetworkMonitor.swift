//
//  NetworkMonitor.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI
import Network

extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
}

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitorQueue")
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                NotificationCenter.default.post(
                    name: .reachabilityChanged,
                    object: self.isConnected
                )
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
