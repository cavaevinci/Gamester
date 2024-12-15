//
//  Platform.swift
//  Gamester
//
//  Created by Erik Đurkan on 13.12.2024..
//

import Foundation

struct Platform: Codable, Equatable {
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
    
    static func == (lhs: Platform, rhs: Platform) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PlatformsResponse: Codable {
    let count: Int
    let results: [Platform]
}
