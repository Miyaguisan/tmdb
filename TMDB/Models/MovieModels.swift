// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


struct Movie: Codable {
    public let id: Int
    public let original_language: String?
    public let original_title: String
    public let overview: String
    public let poster_path: String?
    public let release_date: Date?
    public let runtime: Int?
    public let title: String
    public let vote_average: Double
    public let vote_count: Int
}

struct MoviePage: Codable {
    public let page: Int
    public let results: [Movie]
    public let total_pages: Int
    public let total_results: Int
}
