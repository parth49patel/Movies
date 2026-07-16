//
//  NetworkError.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

enum NetworkError: Error, LocalizedError {
	case invalidURL
	case invalidResponse
	case httpError(statusCode: Int)
	case decodingError(Error)
	case underlying(Error)
	case noInternet
	
	var errorDescription: String? {
		switch self {
			case .invalidURL: return "The request URL was invalid."
			case .invalidResponse: return "The response was invalid."
			case .httpError(let statusCode): return "The server returned an HTTP Error: \(statusCode)"
			case .decodingError(let error): return "Failed to decode the server response: \(error.localizedDescription)."
			case .underlying(let error): return error.localizedDescription
			case .noInternet: return "No internet connection."
		}
	}
}
