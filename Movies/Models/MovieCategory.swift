//
//  MovieCategory.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import Foundation

enum MovieCategory: String, Identifiable, CaseIterable {
	case nowPlaying = "now_playing"
	case popular = "popular"
	case topRated = "top_rated"
	case trending = "trending"
	
	var id: String { rawValue }
	
	var displayName: String {
		switch self {
			case .nowPlaying: return "Now Playing"
			case .popular: return "Popular"
			case .topRated: return "Top Rated"
			case .trending: return "Trending"
		}
	}
	
	var systemImage: String {
		switch self {
			case .nowPlaying: return "play.fill"
			case .popular: return "flame"
			case .topRated: return "star"
			case .trending: return "chart.line.uptrend.xyaxis"
		}
	}
}
