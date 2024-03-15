//
//  Game.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct Game: Codable {
    let id: Int
    let name: String
    let released: String?
    let imageBackground: String?
    let rating: Double
    let website: String?
    
    let topRating: Double
    let publishers: [Publisher]?
    let description: String?
    let metacritic: Int?

    private enum CodingKeys: String, CodingKey {
        case id, name, released, rating, website
        case imageBackground = "background_image"
        case publishers
        case description = "description_raw"
        case metacritic
        case topRating = "rating_top"
    }
}

struct GamesResponse: Codable {
    let count: Int
    let results: [Game]
}

struct Publisher: Codable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}



