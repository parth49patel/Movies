//
//  MoviesApp.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-13.
//

import SwiftUI
import SwiftData

@main
struct MoviesApp: App {
	
	@State private var monitor = NetworkMonitor.shared
    
	var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(monitor)
				.modelContainer(for: [CachedMovie.self, BookmarkedMovie.self])
        }
    }
}
