//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import Foundation
import SwiftData

@Observable
final class MovieListViewModel {
	
	// MARK: - Variables
	private(set) var state: ViewState<[Movie]> = .idle
	private(set) var currentPage: Int = 1
	private(set) var totalPages: Int = 1
	private(set) var selectedCategory: MovieCategory = .nowPlaying
	private(set) var searchResults: [Movie] = []
	private(set) var isSearching: Bool = false
 
	private var searchTask: Task<Void, Never>?
	private let monitor: NetworkMonitor
	private let cache: MovieCacheManager
	private let service: TMDBServiceProtocol

	init(
		monitor: NetworkMonitor = .shared,
		cache: MovieCacheManager = .shared,
		service: TMDBServiceProtocol = TMDBService()
	) {
		self.monitor = monitor
		self.cache = cache
		self.service = service
	}

	// MARK: - Load Movies
	@MainActor
	func loadMovies(context: ModelContext) async {
		if case .success = state { return }

		let cached = cache.readFromCache(category: selectedCategory.rawValue, page: currentPage, context: context)
		if let cached, !cached.isEmpty {
			state = .success(cached)
			return
		}

		guard monitor.isConnected else {
			state = .failure(NetworkError.noInternet)
			return
		}

		state = .loading
		do {
			let response = try await fetch(page: currentPage)
			totalPages = response.totalPages
			if response.results.isEmpty {
				state = .empty
			} else {
				cache.writeToCache(response.results, category: selectedCategory.rawValue, page: totalPages, context: context)
				state = .success(response.results)
			}
		} catch {
			state = .failure(error)
		}
	}

	// MARK: - Pagination: Loading more movies
	@MainActor
	func loadMore(context: ModelContext) async {
		guard currentPage < totalPages else { return }
		guard case .success(let current) = state else { return }
		guard monitor.isConnected else { return }

		let nextPage = currentPage + 1
		do {
			let response = try await fetch(page: nextPage)
			guard !response.results.isEmpty else { return }
			currentPage = nextPage
			cache.writeToCache(response.results, category: selectedCategory.rawValue, page: nextPage, context: context)
			state = .success(current + response.results)
		} catch {
			// Silent — existing movies stay visible
		}
	}

	// MARK: - Category Selection
	@MainActor
	func selectCategory(_ category: MovieCategory, context: ModelContext) async {
		guard category != selectedCategory else { return }
		selectedCategory = category
		currentPage = 1
		totalPages = 1
		state = .idle
		await loadMovies(context: context)
	}

	// MARK: - Refresh
	@MainActor
	func refresh(context: ModelContext) async {
		currentPage = 1
		totalPages = 1
		state = .idle
		cache.clearCache(category: selectedCategory.rawValue, page: 1, context: context)
		await loadMovies(context: context)
	}

	// MARK: - Fetch Movies (different endpoints)
	private func fetch(page: Int) async throws -> MovieResponse {
		switch selectedCategory {
		case .nowPlaying: return try await service.nowPlaying(page: page)
		case .popular:    return try await service.popular(page: page)
		case .topRated:   return try await service.topRated(page: page)
		case .trending:   return try await service.trending(page: page)
		}
	}
	
	// MARK: - Search
	@MainActor
	func updateSearch(_ query: String) {
		searchTask?.cancel()
		let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !trimmed.isEmpty else {
			isSearching = false
			searchResults = []
			return
		}
		
		isSearching = true
		searchTask = Task {
			try? await Task.sleep(for: .milliseconds(400))
			guard !Task.isCancelled else { return }
			await performSearch(query: trimmed)
		}
	}
	
	@MainActor
	func performSearch(query: String) async {
		guard monitor.isConnected else {
			state = .failure(NetworkError.noInternet)
			return
		}
		
		state = .loading
		do {
			let response = try await service.search(query: query, page: 1)
			guard !Task.isCancelled else { return }
			searchResults = response.results
			state = response.results.isEmpty ? .idle : .success(searchResults)
		} catch {
			guard !Task.isCancelled else { return }
			state = .failure(error)
		}
	}
	
	@MainActor
	func cancelSearch() {
		searchTask?.cancel()
		isSearching = false
		searchResults = []
		state = .idle
	}
}
