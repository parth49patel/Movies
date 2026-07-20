//
//  MovieCacheManager.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-16.
//

import Foundation
import SwiftData

final class MovieCacheManager {
	static let shared = MovieCacheManager()
	
	private init () { }
	
	// MARK: - Time To Live
	private func ttl(for category: String) -> TimeInterval {
		switch category {
			case "now_playing": return 60 * 60 * 24
			case "popular": return 60 * 60 * 12
			case "top_rated": return 60 * 60 * 24 * 7
			case "trending": return 60 * 60 * 24 * 7
			default: return 60 * 60
		}
	}
	
	// MARK: - Write Movies to Cache
	@MainActor
	func writeToCache(_ movies: [Movie], category: String, page: Int, context: ModelContext) {
		clearCache(category: category, page: page, context: context)
		
		for movie in movies {
			let cached = CachedMovie(movie: movie, category: category, page: page)
			context.insert(cached)
		}
		try? context.save()
	}
	
	// MARK: - Read Movies from Cache
	@MainActor
	func readFromCache(category: String, page: Int, context: ModelContext) -> [Movie]? {
		let descriptor = FetchDescriptor<CachedMovie>(
			predicate: #Predicate { $0.category == category && $0.page == page },
			sortBy: [SortDescriptor(\.cachedAt, order: .reverse)]
		)
		guard let results = try? context.fetch(descriptor), let first = results.first else { return nil }
		let age = Date.now.timeIntervalSince(first.cachedAt)
		guard age < ttl(for: category) else {
			clearCache(category: category, page: page, context: context)
			return nil
		}
		return results.map { $0.toMovie() }
	}
	
	// MARK: - Clear Cache
	@MainActor
	func clearCache(category: String, page: Int, context: ModelContext) {
		let descriptor = FetchDescriptor<CachedMovie>(
			predicate: #Predicate { $0.category == category && $0.page == page }
		)
		if let results = try? context.fetch(descriptor) {
			results.forEach { context.delete($0) }
			try? context.save()
		}
	}
	
	@MainActor
	func clearAll(context: ModelContext) {
		try? context.delete(model: CachedMovie.self)
		try? context.save()
	}
}
