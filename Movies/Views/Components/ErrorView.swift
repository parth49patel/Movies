//
//  ErrorView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import SwiftUI

struct ErrorView: View {
	let message: String
	let onRetry: () -> Void
	
    var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "wifi.exclamationmark")
				.font(.system(size: 48))
				.foregroundStyle(.secondary)
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
			Button("Retry", action: onRetry)
				.buttonStyle(.bordered)
		}
    }
}

#Preview {
	ErrorView(message: "Something went wrong.", onRetry: {} )
}
