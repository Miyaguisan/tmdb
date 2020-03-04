// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


struct TVShowNetwork: Codable {
    public let id: Int
    public let logo_path: String?
    public let name: String
}

struct TVShowCreator: Codable {
    public let id: Int
    public let name: String
}

struct TVShow: Codable {
    public let created_by: TVShowCreator?
    public let first_air_date: Date?
    public let homepage: String?
    public let id: Int
    public let networks: [TVShowNetwork]?
    public let number_of_episodes: Int?
    public let original_language: String?
    public let original_name: String
    public let overview: String
    public let poster_path: String?
    public let vote_average: Double
    public let vote_count: Int
}

struct TVShowPage: Codable {
    public let page: Int
    public let results: [TVShow]
    public let total_pages: Int
    public let total_results: Int
}
