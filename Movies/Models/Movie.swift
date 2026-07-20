//
//  Movie.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable, Equatable {
	let id: Int
	let title: String
	let overview: String
	let posterPath: String?
	let backdropPath: String?
	let releaseDate: String
	let voteAverage: Double
	let genreIds: [Int]
	
	enum CodingKeys: String, CodingKey {
		case id, title, overview, posterPath = "poster_path", backdropPath = "backdrop_path", voteAverage = "vote_average", releaseDate = "release_date", genreIds = "genre_ids"
	}
}

struct MovieResponse: Codable {
	let page: Int
	let results: [Movie]
	let totalPages: Int
	let totalResults: Int
	
	enum CodingKeys: String, CodingKey {
		case page, results, totalPages = "total_pages", totalResults = "total_results"
	}
}
