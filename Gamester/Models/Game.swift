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
    let rating: Double?
    let playTime: Int?
    let website: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, released, rating, website
        case imageBackground = "background_image"
        case playTime = "playtime"
    }
}

struct GamesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}


