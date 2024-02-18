//
//  UserDefaultsService.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

// Define a struct to represent the selected game genre
struct SelectedGenre: Codable {
    let genre: Int
}

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private let selectedGenreKey = "selectedGenre"
    
    // Function to save selected genre
    func saveSelectedGenre(_ genre: Int) {
        let selectedGenre = SelectedGenre(genre: genre)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedGenre) {
            UserDefaults.standard.set(encoded, forKey: selectedGenreKey)
        }
    }
    
    // Function to retrieve selected genre
    func getSelectedGenre() -> Int? {
        if let savedGenre = UserDefaults.standard.object(forKey: selectedGenreKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedGenre = try? decoder.decode(SelectedGenre.self, from: savedGenre) {
                return loadedGenre.genre
            }
        }
        return nil
    }
}
