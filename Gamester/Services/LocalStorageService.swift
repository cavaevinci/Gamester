//
//  LocalStorageService.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation
import SwiftyBeaver

protocol LocalStorageServiceProtocol {
    func saveSelectedGenres(_ genres: [Genre])
    func getSelectedGenres() -> [Genre]
}

class LocalStorageService: LocalStorageServiceProtocol {
    
    private let selectedGenresKey = "selectedGenre"
    private let userDefaults: UserDefaults
    let log = SwiftyBeaver.self
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveSelectedGenres(_ genres: [Genre]) {
        do {
            let encodedData = try JSONEncoder().encode(genres)
            userDefaults.set(encodedData, forKey: selectedGenresKey)
            log.debug("\(type(of: self)): saveSelectedGenres called")
        } catch {
            log.error("\(type(of: self)): \(error)")
        }
    }
    
    func getSelectedGenres() -> [Genre] {
        if let savedData = userDefaults.data(forKey: selectedGenresKey) {
            do {
                let genres = try JSONDecoder().decode([Genre].self, from: savedData)
                log.debug("\(type(of: self)): getSelectedGenres called")
                return genres
            } catch {
                log.error("\(type(of: self)): \(error)")
                return []
            }
        }
        return []
    }
}
