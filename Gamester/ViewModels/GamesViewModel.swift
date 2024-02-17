//
//  GamesViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import Foundation
import UIKit

class GamesViewModel {
    
    // MARK: - Callbacks
    var onGamesUpdated: (()->Void)?
    
    // MARK: - Variables
    private(set) var genreID: Int
    private(set) var allGames: [Game] = [] {
        didSet {
            self.onGamesUpdated?()
        }
    }
    
    private(set) var filteredGames: [Game] = []
    
    // MARK: - Initializer
    init(_ genreID: Int) {
        self.genreID = genreID
        self.fetchGames()
    }
    
    //refactor
    public func fetchGames() {
        let apiService = APIService()
        apiService.fetchGamesInGenre(apiKey: Constants.API_KEY, genreID: self.genreID) { result in
            switch result {
            case .success(let games):
                print("Fetched games: \(games)")
                self.allGames = games
            case .failure(let error):
                print("Error fetching genres: \(error)")
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

