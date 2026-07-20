//
//  Credits.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-19.
//

import Foundation

struct CreditsResponse: Codable {
	let cast: [CastMember]
}

struct CastMember: Codable, Identifiable, Hashable {
	let id: Int
	let name: String
	let character: String
	let profilePath: String?
	
	enum CodingKeys: String, CodingKey {
		case id, name, character
		case profilePath = "profile_path"
	}
}
