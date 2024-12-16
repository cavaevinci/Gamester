import Foundation

protocol LocalStorageServiceProtocol {
    func save<T: Codable>(_ value: T, forKey key: LocalStorageKey) -> Result<Void, LocalStorageError>
    func get<T: Codable>(forKey key: LocalStorageKey) -> Result<T, LocalStorageError>
    func remove(forKey key: LocalStorageKey) -> Result<Void, LocalStorageError>
    func isFirstRun() -> Bool
}

enum LocalStorageError: Error, Equatable {
    case encodingError
    case decodingError
    case dataNotFound
    case unknownError
}

enum LocalStorageKey: String {
    case selectedGenres
    case selectedPlatforms
}

class LocalStorageService: LocalStorageServiceProtocol {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func isFirstRun() -> Bool {
        let genresResult: Result<[Genre], LocalStorageError> = get(forKey: .selectedGenres)
        let platformsResult: Result<[Platform], LocalStorageError> = get(forKey: .selectedPlatforms)
        
        switch (genresResult, platformsResult) {
        case (.failure(.dataNotFound), _), (_, .failure(.dataNotFound)):
            return true
        case (.success(let genres), .success(let platforms)) where genres.isEmpty || platforms.isEmpty:
            return true
        default:
            return false
        }
    }
    
    func save<T: Codable>(_ value: T, forKey key: LocalStorageKey) -> Result<Void, LocalStorageError> {
        do {
            let encodedData = try JSONEncoder().encode(value)
            userDefaults.set(encodedData, forKey: key.rawValue)
            return .success(())
        } catch {
            return .failure(.encodingError)
        }
    }
    
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
    
    func remove(forKey key: LocalStorageKey) -> Result<Void, LocalStorageError> {
        userDefaults.removeObject(forKey: key.rawValue)
        return .success(())
    }
}
