//
//  Genre.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GenresResponse: Codable {
    let count: Int
    let results: [Genre]
}
