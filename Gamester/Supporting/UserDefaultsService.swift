//
//  UserDefaultsService.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func saveSelectedGenre(_ genre: Int)
    func getSelectedGenre() -> Int?
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    
    private let selectedGenreKey = "selectedGenre"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveSelectedGenre(_ genre: Int) {
        userDefaults.set(genre, forKey: selectedGenreKey)
    }
    
    func getSelectedGenre() -> Int? {
        return userDefaults.integer(forKey: selectedGenreKey) != 0 ? userDefaults.integer(forKey: selectedGenreKey) : nil
    }
}
