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
    var body: some Scene {
        WindowGroup {
            ContentView()
				.modelContainer(for: CachedMovie.self)
        }
    }
}
