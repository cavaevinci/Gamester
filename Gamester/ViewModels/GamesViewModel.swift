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
    internal var currentPage: Int = 1

    private(set) var allGames: [Game] = [] {
        didSet {
            self.onGamesUpdated?()
        }
    }
    
    private(set) var filteredGames: [Game] = []
    
    // MARK: - Callbacks
    var onGamesUpdated: (()->Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializer
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.fetchGames()
    }
    
    public func fetchGames() {
        if let genre = LocalStorageService().getSelectedGenre() {
            apiService.fetchData(from: .gamesInGenre(genreID: genre), responseType: GamesResponse.self) { result in
                switch result {
                case .success(let games):
                    self.allGames = games.results
                case .failure(let error):
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
            filterGamesLocally(with: searchText)
        } else {
            self.filteredGames = self.allGames
            self.onGamesUpdated?()
        }
    }
    
    private func filterGamesLocally(with searchText: String) {
        self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText) })
        
        if self.filteredGames.isEmpty {
            fetchGamesWithSearchText(searchText)
        } else {
            self.onGamesUpdated?()
        }
    }
    
    internal func fetchGamesWithSearchText(_ searchText: String) {
        if let genre = LocalStorageService().getSelectedGenre() {
            apiService.fetchData(from: .gamesInGenre(genreID: genre), search: searchText, page: self.currentPage, responseType: GamesResponse.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let games):
                    let newGames = games.results.filter { newGame in
                        !self.allGames.contains(where: { existingGame in
                            return existingGame.id == newGame.id
                        })
                    }
                    self.allGames += newGames
                    self.filteredGames = self.allGames.filter({ $0.name.lowercased().contains(searchText) })
                    self.onGamesUpdated?()
                case .failure(let error):
                    self.onError?("Error fetching game details: \(error.localizedDescription)")
                }
            }
        }
    }
}

