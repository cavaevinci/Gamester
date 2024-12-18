//
//  APIEndpoint.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

enum APIEndpoint {
    case gameDetails(gameID: Int)
    case gamesInGenreForPlatform(genresIDs: String, platformsIDs: String)
    case genres
    case platforms
    
    var urlString: String {
        switch self {
        case .gameDetails(let gameID):
            return "https://api.rawg.io/api/games/\(gameID)"
        case .gamesInGenreForPlatform:
            return "https://api.rawg.io/api/games"
        case .genres:
            return "https://api.rawg.io/api/genres"
        case .platforms:
            return "https://api.rawg.io/api/platforms"
        }
    }
}
