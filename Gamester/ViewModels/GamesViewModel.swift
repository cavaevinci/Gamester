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
    
    private(set) var allGames: [Game] = [] {
        didSet {
            self.onGamesUpdated?()
        }
    }
    
    private(set) var filteredGames: [Game] = []
    
    // MARK: - Initializer
    init() {
        self.fetchGames()
        print("fetch games model init")
    }
    
    //refactor
    public func fetchGames() {
        if let genre = UserDefaultsService.shared.getSelectedGenre() {
            print("Selected genre: \(genre)")
            let apiService = APIService()
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

