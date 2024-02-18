//
//  APIEndpoint.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

enum APIEndpoint {
    case gameDetails(gameID: Int)
    case gamesInGenre(genreID: Int)
    case genres
    
    var urlString: String {
        switch self {
        case .gameDetails(let gameID):
            return "https://api.rawg.io/api/games/\(gameID)"
        case .gamesInGenre(_):
            return "https://api.rawg.io/api/games"
        case .genres:
            return "https://api.rawg.io/api/genres"
        }
    }
}
