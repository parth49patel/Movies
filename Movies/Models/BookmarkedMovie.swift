//
//  BookmarkedMovie.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-22.
//

import Foundation
import SwiftData

@Model
class BookmarkedMovie {
	var id: Int
	var title: String
	var overview: String
	var posterPath: String?
	var backdropPath: String?
	var releaseDate: String
	var voteAverage: Double
	var genreIds: String
	var bookmarkedAt: Date
	
	init(movie: Movie) {
		self.id = movie.id
		self.title = movie.title
		self.overview = movie.overview
		self.posterPath = movie.posterPath
		self.backdropPath = movie.backdropPath
		self.releaseDate = movie.releaseDate
		self.voteAverage = movie.voteAverage
		self.genreIds = movie.genreIds.map(String.init).joined(separator: ",")
		self.bookmarkedAt = Date()
	}
	
	func toMovie() -> Movie {
		Movie(
			id: id,
			title: title,
			overview: overview,
			posterPath: posterPath,
			backdropPath: backdropPath,
			releaseDate: releaseDate,
			voteAverage: voteAverage,
			genreIds: genreIds.split(separator: ",").compactMap { Int($0) }
		)
	}
}
