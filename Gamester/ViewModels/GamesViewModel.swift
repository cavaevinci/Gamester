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
                    print("Error fetching games: \(error)")
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
        self.filteredGames = allGames
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onGamesUpdated?(); return }
            
            self.filteredGames = self.filteredGames.filter({ $0.name.lowercased().contains(searchText) })
        }
        self.onGamesUpdated?()
    }
}

