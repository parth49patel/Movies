//
//  ContentView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		MovieListView()
    }
}

#Preview {
    ContentView()
		.environment(NetworkMonitor.shared)
}
