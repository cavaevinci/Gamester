//
//  Game.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct Game {
    let id: Int
    let name: String
    let released: String
    let background_image: String
    let rating: Int
    let playtime: Int
    
    var mockImg: URL? {
        return URL(string: "https://s2.coinmarketcap.com/static/img/coins/200x200/1.png")
    }

}
