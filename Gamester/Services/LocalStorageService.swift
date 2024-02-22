//
//  LocalStorageService.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

protocol LocalStorageServiceProtocol {
    func saveSelectedGenres(_ genres: [Genre])
    func getSelectedGenres() -> [Genre]
}

class LocalStorageService: LocalStorageServiceProtocol {
    
    private let selectedGenresKey = "selectedGenre"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveSelectedGenres(_ genres: [Genre]) {
        do {
            let encodedData = try JSONEncoder().encode(genres)
            userDefaults.set(encodedData, forKey: selectedGenresKey)
        } catch {
            print("Error encoding genres: \(error)")
        }
    }
    
    func getSelectedGenres() -> [Genre] {
        if let savedData = userDefaults.data(forKey: selectedGenresKey) {
            do {
                let genres = try JSONDecoder().decode([Genre].self, from: savedData)
                return genres
            } catch {
                print("Error decoding genres: \(error)")
                return []
            }
        }
        return []
    }
}
