//
//  Genre.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct GenreArray {
    let data: [Genre]
}

struct Genre {
    let id: Int
    let name: String
    let games_count: Int
    let image_background: String
    let games: [Game]
    
    var mockImg: URL? {
        return URL(string: "https://s2.coinmarketcap.com/static/img/coins/200x200/1.png")
    }

}

