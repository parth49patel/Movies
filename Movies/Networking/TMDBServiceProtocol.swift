//
//  TMDBServiceProtocol.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

protocol TMDBServiceProtocol {
	func nowPlaying(page: Int) async throws -> MovieResponse
	func popular(page: Int) async throws -> MovieResponse
	func topRated(page: Int) async throws -> MovieResponse
	func trending(page: Int) async throws -> MovieResponse
	func search(query: String, page: Int) async throws -> MovieResponse
}
