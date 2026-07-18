//
//  MovieCardView.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import SwiftUI

struct MovieCardView: View {
	let movie: Movie
	
    var body: some View {
		HStack(spacing: 12) {
			AsyncImage(url: posterURL) { phase in
				switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					case .failure:
						placeholderImage
					default:
						placeholderImage
							.overlay(ProgressView())
				}
			}
			.frame(width: 60, height: 90)
			.clipShape(RoundedRectangle(cornerRadius: 8))
			
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
					Text("\(movie.voteAverage)")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
		}
    }
	
	private var posterURL: URL? {
		guard let path = movie.posterPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
	}
	
	private var placeholderImage: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(Color.secondary.opacity(0.2))
			.overlay {
				Image(systemName: "film")
					.foregroundStyle(.secondary)
			}
	}
}

#Preview {
	MovieCardView(movie: Movie(
		id: 28,
		title: "",
		overview: "",
		posterPath: "",
		backdropPath: "",
		releaseDate: "",
		voteAverage: 9.8,
		genreIds: [1, 3])
	)
}
