//
//  NetworkMonitor.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-17.
//

import Foundation
import Network

@Observable
final class NetworkMonitor {
	static let shared = NetworkMonitor()
	
	private(set) var isConnected: Bool = true
	private(set) var connectionType: ConnectionType = .unknown
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")
	
	enum ConnectionType {
		case cellular, wifi, ethernet, unknown
	}
	
	private init() {
		startMonitoring()
	}
	
	private func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.async {
				self?.isConnected = path.status == .satisfied
				self?.connectionType = self?.getConnectionType(path) ?? .unknown
			}
		}
		monitor.start(queue: queue)
	}
	
	private func getConnectionType(_ path: NWPath) -> ConnectionType {
		if path.usesInterfaceType(.cellular) { return .cellular }
		else if path.usesInterfaceType(.wifi) { return .wifi }
		else if path.usesInterfaceType(.wiredEthernet) { return .ethernet }
		else { return .unknown }
	}
	
	private func stopMonitoring() {
		monitor.cancel()
	}
}
