//
//  BookmarkManager.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-22.
//

import Foundation
import SwiftData

@MainActor
final class BookmarkManager {
	static let shared = BookmarkManager()
	private init() { }
	
	func isBookmarked(id: Int, context: ModelContext) -> Bool {
		let descriptor = FetchDescriptor<BookmarkedMovie>(
			predicate: #Predicate { $0.id == id }
		)
		return (try? context.fetch(descriptor).isEmpty) == false
	}
	
	func bookmark(_ movie: Movie, context: ModelContext) {
		guard !isBookmarked(id: movie.id, context: context) else { return }
		let bookmarked = BookmarkedMovie(movie: movie)
		context.insert(bookmarked)
		try? context.save()
	}
	
	func removeBookmark(id: Int, context: ModelContext) {
		let descriptor = FetchDescriptor<BookmarkedMovie>(
			predicate: #Predicate { $0.id == id }
		)
		guard let results = try? context.fetch(descriptor),
			  let existing = results.first else { return }
		context.delete(existing)
		try? context.save()
	}
	
	func toggleBookmark(_ movie: Movie, context: ModelContext) {
		if !isBookmarked(id: movie.id, context: context) {
			bookmark(movie, context: context)
		} else {
			removeBookmark(id: movie.id, context: context)
		}
	}
	
	func fetchAll(context: ModelContext) -> [Movie] {
		let descriptor = FetchDescriptor<BookmarkedMovie>(
			sortBy: [SortDescriptor(\.bookmarkedAt, order: .reverse)]
		)
		return (try? context.fetch(descriptor))?.map { $0.toMovie() } ?? []
	}
}
