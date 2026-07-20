//
//  MovieListView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import SwiftUI
import SwiftData

struct MovieListView: View {
	@Environment(\.modelContext) private var context
	@Environment(NetworkMonitor.self) private var monitor

	@State private var vm = MovieListViewModel()

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				categoryTabs
				contentView
			}
			.navigationTitle(vm.selectedCategory.displayName)
			.task {
				await vm.loadMovies(context: context)
			}
			.refreshable {
				Task { await vm.loadMovies(context: context) }
			}
		}
	}
	
	// MARK: - contentView
	@ViewBuilder
	private var contentView: some View {
		switch vm.state {
			case .idle, .loading:
				LoadingView(message: "Loading \(vm.selectedCategory.displayName)...")
			case .empty:
				ErrorView(message: "No movies found for this category.") {
					Task { await vm.loadMovies(context: context) }
				}
			case .success(let movies):
				movieList(movies)
			case .failure(let error):
				ErrorView(message: error.localizedDescription) {
					Task { await vm.loadMovies(context: context) }
				}
		}
	}
	
	// MARK: - Movie List
	private func movieList(_ movies: [Movie]) -> some View {
		List {
			ForEach(movies) { movie in
				NavigationLink(value: movie) {
					MovieCardView(movie: movie)
				}
				.listRowSeparator(.hidden)
				.onAppear {
					if movie == movies.last {
						Task { await vm.loadMore(context: context) }
					}
				}
			}
		}
		.listStyle(.plain)
		.refreshable {
			await vm.loadMore(context: context)
		}
		.navigationDestination(for: Movie.self) { movie in
			MovieDetailView(vm: MovieDetailViewModel(movieId: movie.id))
		}
	}
	
	// MARK: - Category Tabs (Capsule Shaped)
	private var categoryTabs: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(MovieCategory.allCases) { category in
					Button {
						Task { await vm.selectCategory(category, context: context) }
					} label: {
						Text(category.displayName)
							.font(.subheadline)
							.fontWeight(.medium)
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
							.background(
								vm.selectedCategory == category ? Color.blue : Color(.systemGray6)
							)
							.foregroundStyle(
								vm.selectedCategory == category ? .white : .primary
							)
							.clipShape(Capsule())
					}
				}
			}
		}
		.padding(.horizontal)
		.padding(.vertical, 8)
	}
}

#Preview {
	MovieListView()
		.environment(NetworkMonitor.shared)
}
