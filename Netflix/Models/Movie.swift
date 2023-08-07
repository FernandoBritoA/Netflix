//
//  Movie.swift
//  Netflix
//
//  Created by Fernando Brito on 06/08/23.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let vote_average: Double
    let release_date: String?
}

struct TrendingMoviesResponse: Codable {
    let results: [Movie]
}


