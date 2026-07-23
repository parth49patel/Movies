//
//  MovieDetailView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-19.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
	
	@Environment(NetworkMonitor.self) private var monitor
	@Environment(\.modelContext) private var context
	@State var vm: MovieDetailViewModel
	
	var body: some View {
		Group {
			switch vm.state {
				case .idle, .loading:
					LoadingView(message: "Loading movie details...")
				case .success(let detail):
					detailContent(detail)
				case .empty:
					ErrorView(message: "No details found.") {
						Task { await vm.refresh() }
					}
				case .failure(let error):
					ErrorView(message: error.localizedDescription) {
						Task { await vm.load() }
					}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .automatic) {
				if case .success(let detail) = vm.state {
					let movie = Movie(
						id: detail.id,
						title: detail.title,
						overview: detail.overview,
						posterPath: detail.posterPath,
						backdropPath: detail.backdropPath,
						releaseDate: detail.releaseYear,
						voteAverage: detail.voteAverage,
						genreIds: detail.genres.map { $0.id }
					)
					let isBookmarked = BookmarkManager.shared.isBookmarked(id: detail.id, context: context)
					Button {
						BookmarkManager.shared.bookmark(movie, context: context)
					} label: {
						Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
							.foregroundStyle(isBookmarked ? .blue : .secondary)
					}
				}
			}
		}
		.task { await vm.load() }
		.onChange(of: monitor.isConnected) { _, isConnected in
			if isConnected {
				Task { await vm.load() }
			}
		}
	}
	
	@ViewBuilder
	private func detailContent(_ detail: MovieDetail) -> some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				backdropImage(detail)
				infoSection(detail)
				if !vm.cast.isEmpty {
					castSection
				}
			}
		}
		.refreshable { await vm.refresh() }
		.navigationTitle(detail.title)
	}
	
	// MARK: - Backdrop section
	private func backdropImage(_ detail: MovieDetail) -> some View {
		AsyncImage(url: backdropURL(detail)) { phase in
			switch phase {
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				default:
					Color.secondary.opacity(0.2)
			}
		}
		.frame(height: 220)
		.clipped()
	}
	
	// MARK: - Information Section
	private func infoSection(_ detail: MovieDetail) -> some View {
		VStack(alignment: .leading, spacing: 12) {
			if let tagline = detail.tagline, !tagline.isEmpty {
				Text(tagline)
					.font(.subheadline)
					.italic()
					.foregroundStyle(.secondary)
			}
			
			HStack(spacing: 16) {
				Label(detail.formattedRating, systemImage: "star.fill")
					.foregroundStyle(.yellow)
				Label(detail.formattedRunTime, systemImage: "clock")
				Label(detail.releaseYear, systemImage: "calendar")
			}
			.font(.subheadline)
			.foregroundStyle(.secondary)
			
			if !detail.genres.isEmpty {
				genreTags(detail.genres)
			}
			
			Divider()
			
			Text("Overview")
				.font(.headline)
			Text(detail.overview)
				.font(.body)
				.foregroundStyle(.secondary)
		}
		.padding()
	}
	
	// MARK: - Genres
	private func genreTags(_ genres: [Genre]) -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(genres) { genre in
					Text(genre.name)
						.font(.caption)
						.padding(.horizontal, 10)
						.padding(.vertical, 4)
						.background(Color.blue.opacity(0.15))
						.foregroundStyle(.blue)
						.clipShape(Capsule())
				}
			}
		}
	}
	
	// MARK: - Cast Seciton
	private var castSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Cast")
				.font(.headline)
				.padding(.horizontal)
			
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .top, spacing: 12) {
					ForEach(vm.cast.prefix(10)) { member in
						castMemberView(member)
					}
				}
				.padding(.horizontal)
			}
		}
		.padding(.bottom)
	}
	
	private func castMemberView(_ member: CastMember) -> some View {
		VStack(spacing: 6) {
			AsyncImage(url: profileURL(member)) { phase in
				if case .success(let image) = phase {
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				} else {
					Color.secondary.opacity(0.2)
						.overlay(
							Image(systemName: "person.fill")
								.foregroundStyle(.secondary)
						)
				}
			}
			.frame(width: 70, height: 70)
			.clipShape(Circle())
			
			Text(member.name)
				.font(.caption)
				.fontWeight(.medium)
				.lineLimit(1)
				.frame(width: 80)
			
			Text(member.character)
				.font(.caption2)
				.foregroundStyle(.secondary)
				.lineLimit(1)
				.frame(width: 80)
		}
	}
	
	// MARK: - URL Helpers
	private func backdropURL(_ detail: MovieDetail) -> URL? {
		guard let path = detail.backdropPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
	}
	
	private func profileURL(_ member: CastMember) -> URL? {
		guard let path = member.profilePath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
	}
}

#Preview {
	NavigationStack {
		MovieDetailView(vm: MovieDetailViewModel(movieId: 502356))
			.environment(NetworkMonitor.shared)
	}
}
