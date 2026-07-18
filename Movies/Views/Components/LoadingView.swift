//
//  LoadingView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import SwiftUI

struct LoadingView: View {
	var message: String = "Loading..."
	
    var body: some View {
		VStack(spacing: 12) {
			ProgressView()
				.controlSize(.large)
			Text(message)
				.font(.headline)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
