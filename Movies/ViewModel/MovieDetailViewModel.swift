//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-19.
//

import Foundation

@Observable
final class MovieDetailViewModel {
	private(set) var state: ViewState<MovieDetail> = .idle
	private(set) var cast: [CastMember] = []
	
	private let movieId: Int
	private let service: TMDBServiceProtocol
	private let monitor: NetworkMonitor
	
	init(movieId: Int, service: TMDBServiceProtocol = TMDBService(), monitor: NetworkMonitor = .shared) {
		self.movieId = movieId
		self.service = service
		self.monitor = monitor
	}
	
	@MainActor
	func load() async {
		if case .success = state { return }
		guard monitor.isConnected else {
			state = .failure(NetworkError.noInternet)
			return
		}
		
		state = .loading
		do {
			async let detailResult = try await service.movieDetail(id: movieId)
			async let creditResult = try await service.credits(id: movieId)
			let (detail, credit) = try await (detailResult, creditResult)
			cast = credit.cast
			state = .success(detail)
		} catch {
			state = .failure(error)
		}
	}
	
	@MainActor
	func refresh() async {
		state = .idle
		await load()
	}
}
