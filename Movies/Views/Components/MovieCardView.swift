//
//  MovieCardView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import SwiftUI
import SwiftData

struct MovieCardView: View {
	let movie: Movie
	let context: ModelContext
	
    var body: some View {
		HStack(spacing: 12) {
			posterImage
			movieInfo
			Spacer()
			bookmarkButton
		}
    }
	
	// MARK: - Poster Image
	private var posterImage: some View {
		AsyncImage(url: posterURL) { phase in
			switch phase {
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				default:
					Color.secondary.opacity(0.2)
						.overlay {
							Image(systemName: "film")
								.foregroundStyle(.secondary)
						}
			}
		}
		.frame(width: 60, height: 90)
		.clipShape(RoundedRectangle(cornerRadius: 8))
	}
	
	// MARK: - Movie Info
	private var movieInfo: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(movie.title)
				.font(.headline)
				.lineLimit(2)
			Text(movie.releaseDate)
				.font(.subheadline)
				.foregroundColor(.secondary)
			
			HStack(spacing: 4) {
				Image(systemName: "star.fill")
					.font(.caption)
					.foregroundStyle(.yellow)
				Text("\(movie.voteAverage, format: .number.precision(.fractionLength(2)))")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
	}
	
	// MARK: - Bookmark Button
	private var bookmarkButton: some View {
		let isBookmarked = BookmarkManager.shared.isBookmarked(id: movie.id, context: context)
		return Button {
			BookmarkManager.shared.toggleBookmark(movie, context: context)
		} label: {
			Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
				.foregroundStyle(isBookmarked ? .blue : .secondary)
		}
		.buttonStyle(.plain)
	}
	
	// MARK: - URL Helper
	private var posterURL: URL? {
		guard let path = movie.posterPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: BookmarkedMovie.self, configurations: config)
	MovieCardView(
		movie: Movie(
			id: 28,
			title: "The Dark Knight",
			overview: "Batman raises the stakes in his war on crime.",
			posterPath: nil,
			backdropPath: nil,
			releaseDate: "2008",
			voteAverage: 9.8,
			genreIds: [28, 18]
		), context: container.mainContext
	)
	.modelContainer(container)
}
