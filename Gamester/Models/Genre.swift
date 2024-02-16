//
//  Genre.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int?
    let imageBackground: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct GenresResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Genre]
}
