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
	@State private var searchQuery: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				if let banner = vm.banner {
					OfflineBannerView(state: banner) {
						Task { await vm.refreshAfterReconnection(context: context) }
					}
					.transition(.move(edge: .top).combined(with: .opacity))
				}
				contentView
			}
			.animation(.easeInOut(duration: 0.3), value: vm.banner != nil)
			.navigationTitle(vm.isFilteringBookmarks ? "Bookmarks" : "Movies")
			.searchable(text: Binding(
				get: { searchQuery },
				set: {
					searchQuery = $0
					vm.updateSearch($0)
				}
			), prompt: "Search movies...")
			.onSubmit(of: .search) {
				vm.updateSearch(searchQuery)
			}
			.toolbar {
				ToolbarItem(placement: .automatic) {
					Button {
						vm.toggleBookmarkFilter(context: context)
					} label: {
						Image(systemName: vm.isFilteringBookmarks ? "bookmark.fill" : "bookmark")
					}
				}
			}
			.task {
				await vm.loadMovies(context: context)
			}
			.onChange(of: monitor.isConnected) { _, isConnected in
				vm.handleConnectivityChanges(isConnected: isConnected, context: context)
			}
			.navigationDestination(for: Movie.self) { movie in
				MovieDetailView(vm: MovieDetailViewModel(movieId: movie.id))
			}
		}
	}
	
	// MARK: - contentView
	@ViewBuilder
	private var contentView: some View {
		switch vm.state {
			case .idle, .loading:
				LoadingView(message: vm.isSearching ? "Searching..." : "Loading \(vm.selectedCategory.displayName)...")
			
			case .empty:
				placeholderView(
					icon: vm.isFilteringBookmarks ? "bookmark.slash" : "questionmark.circle",
					message: vm.isFilteringBookmarks ? "No bookmarks yet" : vm.isSearching ? "No results found" : "No movies found"
				)
			
			case .success(let movies):
				movieList(vm.isSearching ? vm.searchResults : movies)
			
			case .failure(let error):
				ErrorView(message: error.localizedDescription) {
					Task { await vm.retry(context: context) }
				}
		}
	}
	
	// MARK: - Movie List
	private func movieList(_ movies: [Movie]) -> some View {
		List {
			if !vm.isSearching && !vm.isFilteringBookmarks {
				Section {
					// empty - header is the tabs
				} header: {
					categoryTabs
						.listRowInsets(EdgeInsets())
						.background(Color(.systemBackground))
				}
			}
			ForEach(movies) { movie in
				NavigationLink(value: movie) {
					MovieCardView(movie: movie, context: context)
				}
				.listRowSeparator(.hidden)
				.onAppear {
					if let lastMovie = movies.last,
					   movie.id == lastMovie.id,
					   !vm.isSearching ,
					   !vm.isFilteringBookmarks {
						Task { await vm.loadMore(context: context) }
					}
				}
			}
		}
		.listStyle(.plain)
		.refreshable {
			if !vm.isSearching && !vm.isFilteringBookmarks {
				await vm.refresh(context: context)
			}
		}
	}
	
	// MARK: - Placeholder View
	private func placeholderView(icon: String, message: String) -> some View {
		VStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 48))
				.foregroundStyle(.secondary)
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
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
