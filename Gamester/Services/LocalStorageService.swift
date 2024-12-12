//
//  LocalStorageService.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

// Protocol for local storage service
protocol LocalStorageServiceProtocol {
    func saveSelectedGenres(_ genres: [Genre]) -> Result<Void, LocalStorageError>
    func getSelectedGenres() -> Result<[Genre], LocalStorageError>
    func removeSelectedGenres() -> Result<Void, LocalStorageError>
}

// Enum for error handling
enum LocalStorageError: Error, Equatable {
    case encodingError
    case decodingError
    case dataNotFound
    case unknownError
}

// LocalStorageService implementation
class LocalStorageService: LocalStorageServiceProtocol {
    
    // Constants to avoid hardcoding keys
    private let selectedGenresKey = "selectedGenre"
    
    // Dependency injection of UserDefaults for better testability
    private let userDefaults: UserDefaults
    
    // Init with default UserDefaults or custom UserDefaults for testing
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    // Save genres with improved error handling
    func saveSelectedGenres(_ genres: [Genre]) -> Result<Void, LocalStorageError> {
        do {
            let encodedData = try JSONEncoder().encode(genres)
            userDefaults.set(encodedData, forKey: selectedGenresKey)
            return .success(())
        } catch {
            return .failure(.encodingError)
        }
    }
    
    // Get saved genres with improved error handling
    func getSelectedGenres() -> Result<[Genre], LocalStorageError> {
        guard let savedData = userDefaults.data(forKey: selectedGenresKey) else {
            return .failure(.dataNotFound)
        }
        
        do {
            let genres = try JSONDecoder().decode([Genre].self, from: savedData)
            return .success(genres)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    // Remove saved genres
    func removeSelectedGenres() -> Result<Void, LocalStorageError> {
        userDefaults.removeObject(forKey: selectedGenresKey)
        return .success(())
    }
}
