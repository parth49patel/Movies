//
//  TMDBService.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

final class TMDBService: TMDBServiceProtocol {
	private let session: URLSession
	
	init(session: URLSession = .shared) {
		self.session = session
	}
	
	func nowPlaying(page: Int) async throws -> MovieResponse {
		try await request(.nowPlaying(page: page))
	}
	
	func popular(page: Int) async throws -> MovieResponse {
		try await request(.popular(page: page))
	}
	
	func topRated(page: Int) async throws -> MovieResponse {
		try await request(.topRated(page: page))
	}
	
	func trending(page: Int) async throws -> MovieResponse {
		try await request(.trending(page: page))
	}
	
	func search(query: String, page: Int) async throws -> MovieResponse {
		try await request(.search(query: query, page: page))
	}
	
	private func request<T: Decodable>(_ endpoint: TMDBEndpoint) async throws -> T {
		guard let url = endpoint.url else { throw NetworkError.invalidURL }
		let data: Data
		let response: URLResponse
		
		do {
			(data, response) = try await session.data(from: url)
		} catch {
			throw NetworkError.underlying(error)
		}
		
		guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
		guard 200...299 ~= httpResponse.statusCode else { throw NetworkError.httpError(statusCode: httpResponse.statusCode) }
		
		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw NetworkError.decodingError(error)
		}
	}
}
