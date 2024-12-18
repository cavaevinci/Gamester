import Foundation

// Protocol for local storage service
protocol LocalStorageServiceProtocol {
    func save<T: Codable>(_ value: T, forKey key: LocalStorageKey) -> Result<Void, LocalStorageError>
    func get<T: Codable>(forKey key: LocalStorageKey) -> Result<T, LocalStorageError>
    func remove(forKey key: LocalStorageKey) -> Result<Void, LocalStorageError>
    func isFirstRun() -> Bool
}

// Enum for error handling
enum LocalStorageError: Error, Equatable {
    case encodingError
    case decodingError
    case dataNotFound
    case unknownError
}

// Enum for predefined keys to ensure type safety
enum LocalStorageKey: String {
    case selectedGenres
    case selectedPlatforms
}

// LocalStorageService implementation
class LocalStorageService: LocalStorageServiceProtocol {
    
    // Dependency injection of UserDefaults for better testability
    private let userDefaults: UserDefaults
    
    // Init with default UserDefaults or custom UserDefaults for testing
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func isFirstRun() -> Bool {
        // Check if genres or platforms are missing from local storage
        let genresResult: Result<[Genre], LocalStorageError> = get(forKey: .selectedGenres)
        let platformsResult: Result<[Platform], LocalStorageError> = get(forKey: .selectedPlatforms)
        
        switch (genresResult, platformsResult) {
        case (.failure(.dataNotFound), _), (_, .failure(.dataNotFound)):
            // If either genres or platforms data is missing, it's the first run
            return true
        case (.success(let genres), .success(let platforms)) where genres.isEmpty || platforms.isEmpty:
            // If either genres or platforms are empty, it's the first run
            return true
        default:
            // Otherwise, not the first run
            return false
        }
    }
    
    // Save a value to UserDefaults
    func save<T: Codable>(_ value: T, forKey key: LocalStorageKey) -> Result<Void, LocalStorageError> {
        do {
            let encodedData = try JSONEncoder().encode(value)
            userDefaults.set(encodedData, forKey: key.rawValue)
            return .success(())
        } catch {
            return .failure(.encodingError)
        }
    }
    
    // Retrieve a value from UserDefaults
    func get<T: Codable>(forKey key: LocalStorageKey) -> Result<T, LocalStorageError> {
        guard let savedData = userDefaults.data(forKey: key.rawValue) else {
            return .failure(.dataNotFound)
        }
        
        do {
            let decodedValue = try JSONDecoder().decode(T.self, from: savedData)
            return .success(decodedValue)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    // Remove a value from UserDefaults
    func remove(forKey key: LocalStorageKey) -> Result<Void, LocalStorageError> {
        userDefaults.removeObject(forKey: key.rawValue)
        return .success(())
    }
}
