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
    //var onErrorMessage: ((CoinServiceError)->Void)?
    
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
    }
    
    public func fetchGames() {
        print(" fetch games---")
        self.allGames.append(Game(id: 1, name: "first", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "second", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "third", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "fourth", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "5th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "6th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "7th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "8th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "9th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "10th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "11th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
        self.allGames.append(Game(id: 1, name: "12th", released: "2222-22-22", background_image: "xx", rating: 2, playtime: 4))
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

