//
//  CachedMovie.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-16.
//

import Foundation
import SwiftData

@Model
class CachedMovie {
	var id: Int
	var title: String
	var overview: String
	var posterPath: String?
	var backdropPath: String?
	var releaseDate: String
	var voteAverage: Double
	var genreIds: String
	var category: String
	var page: Int
	var cachedAt: Date

	init(movie: Movie, category: String, page: Int) {
		self.id = movie.id
		self.title = movie.title
		self.overview = movie.overview
		self.posterPath = movie.posterPath
		self.backdropPath = movie.backdropPath
		self.releaseDate = movie.releaseDate
		self.voteAverage = movie.voteAverage
		self.genreIds = movie.genreIds.map(String.init).joined(separator: ",")
		self.category = category
		self.page = page
		self.cachedAt = Date()
	}
	
	func toMovie() -> Movie {
		return Movie(
			id: id,
			title: title,
			overview: overview,
			posterPath: posterPath,
			backdropPath: backdropPath,
			releaseDate: releaseDate,
			voteAverage: voteAverage,
			genreIds: genreIds.split(separator: ", ").compactMap { Int($0) }
		)
	}
}
