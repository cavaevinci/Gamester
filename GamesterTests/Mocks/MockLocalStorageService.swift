import Foundation

class MockLocalStorageService: LocalStorageServiceProtocol {
    
    private var selectedGenres: [Genre]?
    
    func saveSelectedGenres(_ genres: [Genre]) {
        selectedGenres = genres
    }
    
    func getSelectedGenres() -> [Genre] {
        return selectedGenres ?? []
    }
}