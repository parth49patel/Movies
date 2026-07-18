//
//  ViewState.swift
//  Movies
//
//  Created by Parth Patel on 2026-07-18.
//

import Foundation

enum ViewState<T> {
	case idle
	case empty
	case loading
	case success(T)
	case failure(Error)
}
