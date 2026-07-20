//
//  MovieDetail.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-19.
//

import Foundation

struct MovieDetail: Codable, Identifiable {
	let id: Int
	let title: String
	let overview: String
	let posterPath: String?
	let backdropPath: String?
	let releaseDate: String
	let voteAverage: Double
	let runtime: Int?
	let genres: [Genre]
	let tagline: String?
	
	enum CodingKeys: String, CodingKey {
		case id, title, overview, runtime, genres, tagline
		case posterPath = "poster_path"
		case backdropPath = "backdrop_path"
		case releaseDate = "release_date"
		case voteAverage = "vote_average"
	}
	
	var formattedRating: String {
		String(format: "%.1f", voteAverage)
	}
	
	var releaseYear: String {
		String(releaseDate.prefix(4))
	}
	
	var formattedRunTime: String {
		guard let runtime else { return "-" }
		let hours = runtime / 60
		let minutes = runtime % 60
		return "\(hours)h \(minutes)m"
	}
}

struct Genre: Codable, Identifiable, Hashable {
	let id: Int
	let name: String
}
