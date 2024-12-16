//
//  GamesViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import Foundation
import UIKit

class GamesViewModel {
    
    // MARK: - Variables
    internal let apiService: APIServiceProtocol
    internal let userDefaultsService: LocalStorageServiceProtocol
    internal var currentPage: Int = 1
    private let throttleInterval: TimeInterval = 0.1
    private var isFetchingNextPage = false

    private(set) var allGames: [Game] = [] {
        didSet {
            self.onGamesUpdated?()
        }
    }
    
    private(set) var filteredGames: [Game] = []
    let cellHeight: CGFloat = 220.0
    
    // MARK: - Callbacks
    var onGamesUpdated: (()->Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializer
    init(apiService: APIServiceProtocol, userDefaultsService: LocalStorageServiceProtocol) {
        self.apiService = apiService
        self.userDefaultsService = userDefaultsService
        self.fetchGames()
    }
    
    public func fetchGames() {
        // Handle the result from `getSelectedGenres`
        let genresIDsFromLocalStorage: [Genre]

        let getResult: Result<[Genre], LocalStorageError> = self.userDefaultsService.get(forKey: .selectedGenres)
        switch getResult {
        case .success(let genres):
            print("Retrieved genres: \(genres)")
            genresIDsFromLocalStorage = genres
        case .failure(let error):
            print("Failed to retrieve genres: \(error)")
            genresIDsFromLocalStorage = []
        }
        
        // Transform the genre IDs
        let ids = transformSelectedGenreIDs(genresIDsFromLocalStorage)
        
        // Fetch games based on the IDs
        self.apiService.fetchData(from: .gamesInGenre(genresIDs: ids), responseType: GamesResponse.self) { result in
            switch result {
            case .success(let games):
                self.allGames = games.results
            case .failure(let error):
                self.onError?("Error fetching game details: \(error.localizedDescription)")
            }
        }
    }

}

// MARK: - Search
extension GamesViewModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        if let searchText = searchBarText?.lowercased(), !searchText.isEmpty {
            filterGamesLocally(with: searchText)
        } else {
            self.filteredGames = self.allGames
            self.onGamesUpdated?()
        }
    }
    
    private func filterGamesLocally(with searchText: String) {
        self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText) })
        
        if self.filteredGames.isEmpty {
            //reset current page so search request works poperly
            self.currentPage = 1
            self.fetchGamesWithSearchText(searchText)
        } else {
            self.onGamesUpdated?()
        }
    }
    
    private func transformSelectedGenreIDs(_ genres: [Genre]) -> String {
        let genreIDs: [Int] = genres.map { $0.id }
        let genreIDsString = genreIDs.map { String($0) }.joined(separator: ",")
        return genreIDsString
    }
    
    internal func fetchGamesWithSearchText(_ searchText: String? = nil) {
        guard !isFetchingNextPage else { return }
        isFetchingNextPage = true
        
        // Handle the result from `getSelectedGenres`
        let genresIDsFromLocalStorage: [Genre]
        
        let getResult: Result<[Genre], LocalStorageError> = self.userDefaultsService.get(forKey: .selectedGenres)
        switch getResult {
        case .success(let genres):
            print("Retrieved genres: \(genres)")
            genresIDsFromLocalStorage = genres
        case .failure(let error):
            print("Failed to retrieve genres: \(error)")
            genresIDsFromLocalStorage = []
        }
        
        let ids = transformSelectedGenreIDs(genresIDsFromLocalStorage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + throttleInterval) {
            self.apiService.fetchData(from: .gamesInGenre(genresIDs: ids), search: searchText ?? "", page: self.currentPage, responseType: GamesResponse.self) { [weak self] result in
                guard let self = self else { return }
                self.isFetchingNextPage = false
                switch result {
                case .success(let games):
                    let newGames = games.results.filter { newGame in
                        !self.allGames.contains(where: { existingGame in
                            return existingGame.id == newGame.id
                        })
                    }
                    self.allGames += newGames
                    self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText?.lowercased() ?? "") })
                    self.onGamesUpdated?()
                case .failure(let error):
                    self.onError?("Error fetching game details: \(error.localizedDescription)")
                }
            }
        }
    }

}

