//
//  Genre.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

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

extension Genre {
    public static func getMockArray() -> [Genre] {
        return [
            Genre(id: 1, name: "Test1", games_count: 244, image_background: "x", games: [Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154)]),
            Genre(id: 2, name: "Test3", games_count: 244, image_background: "x", games: [Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154)]),
            Genre(id: 3, name: "Test3", games_count: 244, image_background: "x", games: [Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154) ,Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154) ,Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154), Game(id: 1, name: "game1", released: "2222-33-44", background_image: "xx", rating: 100, playTime: 5154)])
        ]
    }
}
