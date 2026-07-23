//
//  OfflineBannerView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-23.
//

import SwiftUI

enum BannerState: Equatable {
	case offline
	case backOnline
}

struct OfflineBannerView: View {
	let state: BannerState
	var onRefresh: (() -> Void)? = nil
    var body: some View {
		switch state {
			case .offline:
				offlineBanner
			case .backOnline:
				backOnlineBanner
		}
    }
	
	private var offlineBanner: some View {
		HStack {
			Image(systemName: "wifi.slash")
			Text("You're offline - showing cached content")
				.font(.caption)
		}
		.foregroundStyle(.white)
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity)
		.background(Color.orange)
	}
	
	private var backOnlineBanner: some View {
		Button {
			onRefresh?()
		} label: {
			Image(systemName: "wifi")
			Text("Back online - tap to refresh")
				.font(.caption)
			Spacer()
			Image(systemName: "arrow.clockwise")
				.font(.caption)
		}
		.foregroundStyle(.white)
		.padding(.vertical, 8)
		.padding(.horizontal)
		.frame(maxWidth: .infinity)
		.background(Color.green)
	}
}

#Preview {
	OfflineBannerView(state: .backOnline)
}
