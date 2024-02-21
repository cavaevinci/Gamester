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

    private(set) var allGames: [Game] = [] {
        didSet {
            self.onGamesUpdated?()
        }
    }
    
    private(set) var filteredGames: [Game] = []
    
    // MARK: - Callbacks
    var onGamesUpdated: (()->Void)?
    var onError: ((String) -> Void)? // Callback for error handling
    
    // MARK: - Initializer
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.fetchGames()
    }
    
    //refactor
    public func fetchGames() {
        if let genre = LocalStorageService().getSelectedGenre() {
            apiService.fetchData(from: .gamesInGenre(genreID: genre), responseType: GamesResponse.self) { result in
                switch result {
                case .success(let games):
                    self.allGames = games.results
                case .failure(let error):
                    // Pass the error message to the onError callback for handling in the view controller
                    self.onError?("Error fetching game details: \(error.localizedDescription)")
                }
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
                // If search text is not empty, filter the games locally
                filterGamesLocally(with: searchText)
            } else {
                // If search text is empty, reset the filtered games to all games
                self.filteredGames = self.allGames
                self.onGamesUpdated?()
            }
        }
        
        // Filter games locally and fetch from API if no matches found
        private func filterGamesLocally(with searchText: String) {
            self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText) })
            
            // Check if there are any matches
            if self.filteredGames.isEmpty {
                // If no matches found locally, make an API call with the search text
                fetchGamesWithSearchText(searchText)
            } else {
                // Notify the UI that the games have been updated
                self.onGamesUpdated?()
            }
        }
        
        // Fetch games from API with search text
        private func fetchGamesWithSearchText(_ searchText: String) {
            if let genre = LocalStorageService().getSelectedGenre() {
                apiService.fetchData(from: .gamesInGenre(genreID: genre), search: searchText, page: 1, pageSize: 100, responseType: GamesResponse.self) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let games):
                        // Append new games to the existing array, avoiding duplicates
                        let newGames = games.results.filter { newGame in
                            !self.allGames.contains(where: { existingGame in
                                return existingGame.id == newGame.id
                            })
                        }
                        self.allGames += newGames
                        self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText) })
                        self.onGamesUpdated?()
                    case .failure(let error):
                        // Pass the error message to the onError callback for handling in the view controller
                        self.onError?("Error fetching game details: \(error.localizedDescription)")
                    }
                }
            }
        }
}

