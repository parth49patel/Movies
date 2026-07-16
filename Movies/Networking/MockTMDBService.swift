//
//  MockTMDBService.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

final class MockTMDBService: TMDBServiceProtocol {
	
	static let sampleMovies: [Movie] = [
		Movie(
			id: 1,
			title: "The Avengers",
			overview: "Earth's mightiest heroes must come together to stop Loki and his alien army from conquering Earth.",
			posterPath: "/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg",
			backdropPath: "/9BBTo63ANSmhC4e6r62OJFuK2GL.jpg",
			releaseDate: "2012-05-04",
			voteAverage: 7.7,
			genreIds: [28, 12, 878]
		),
		Movie(
			id: 2,
			title: "Inception",
			overview: "A skilled thief who steals corporate secrets through dream-sharing technology is given a chance to have his past crimes erased.",
			posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
			backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
			releaseDate: "2010-07-16",
			voteAverage: 8.4,
			genreIds: [28, 878, 12]
		),
		Movie(
			id: 3,
			title: "Interstellar",
			overview: "A team of explorers travels through a wormhole in space in an attempt to ensure humanity's survival.",
			posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
			backdropPath: "/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
			releaseDate: "2014-11-07",
			voteAverage: 8.5,
			genreIds: [12, 18, 878]
		)
	]
	
	static let sampleResponse = MovieResponse(page: 1, results: sampleMovies, totalPages: 1, totalResults: 3)
	
	func nowPlaying(page: Int) async throws -> MovieResponse {
		return Self.sampleResponse
	}
	
	func popular(page: Int) async throws -> MovieResponse {
		return Self.sampleResponse
	}
	
	func topRated(page: Int) async throws -> MovieResponse {
		return Self.sampleResponse
	}
	
	func trending(page: Int) async throws -> MovieResponse {
		return Self.sampleResponse
	}
	
	func search(query: String, page: Int) async throws -> MovieResponse {
		return Self.sampleResponse
	}
}
