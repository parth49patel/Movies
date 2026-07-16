//
//  TMDBEndpoint.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-15.
//

import Foundation

enum TMDBEndpoint {
	case nowPlaying(page: Int)
	case popular(page: Int)
	case topRated(page: Int)
	case trending(page: Int)
	case search(query: String, page: Int)
	case movieDetail(id: Int)
	case credits(id: Int)
	
	var path: String {
		switch self {
			case .nowPlaying: return "movie/now_playing"
			case .popular: return "movie/popular"
			case .topRated: return "movie/top_rated"
			case .trending: return "movie/trending/day"
			case .search: return "search/movie"
			case .movieDetail(id: let id): return "movie/\(id)"
			case .credits(id: let id): return "movie/\(id)/credits"
		}
	}
	
	var queryItems: [URLQueryItem] {
		var items: [URLQueryItem] = [URLQueryItem(name: "api_key", value: Secrets.tmdbAPIKey)]
		switch self {
			case .nowPlaying(page: let page), .popular(page: let page), .topRated(page: let page), .trending(page: let page):
				items.append(URLQueryItem(name: "page", value: "\(page)"))
			case .search(query: let query, page: let page):
				items.append(URLQueryItem(name: "query", value: query))
				items.append(URLQueryItem(name: "page", value: "\(page)"))
			case .movieDetail, .credits: break
		}
		return items
	}
	
	var url: URL? {
		var components = URLComponents(string: APIConstants.baseURL + path)
		components?.queryItems = queryItems
		return components?.url
	}
}

/*
 
 enum TMDBEndpoint {
	 case nowPlaying(page: Int)
	 case popular(page: Int)
	 case topRated(page: Int)
	 case trending(page: Int)
	 case search(query: String, page: Int)
	 case movieDetail(id: Int)
	 case credits(id: Int)
	 
	 var path: String {
		 switch self {
			 case .nowPlaying: return "movie/now_playing"
			 case .popular: return "movie/popular"
			 case .topRated: return "movie/top_rated"
			 case .trending: return "trending/movie/week"
			 case .search: return "search/movie"
			 case .movieDetail(id: let id): return "movie/\(id)"
			 case .credits(id: let id): return "movie/\(id)/credits"
		 }
	 }
	 
	 var queryItems: [URLQueryItem] {
		 var items: [URLQueryItem] = [URLQueryItem(name: "api_key", value: Secrets.tmdbAPIKey)]
		 switch self {
			 case .nowPlaying(page: let page), .popular(page: let page), .topRated(page: let page), .trending(page: let page):
				 items.append(URLQueryItem(name: "page", value: "\(page)"))
			 case .search(query: let query, page: let page):
				 items.append(URLQueryItem(name: "query", value: query))
				 items.append(URLQueryItem(name: "page", value: "\(page)"))
			 case .movieDetail, .credits:
				 break
		 }
		 return items
	 }
	 
	 var url: URL? {
		 var components = URLComponents(string: APIConstants.baseURL + path)
		 components?.queryItems = queryItems
		 return components?.url
	 }
 }
 */
