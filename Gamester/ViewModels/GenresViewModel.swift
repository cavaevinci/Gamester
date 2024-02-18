//
//  GenresViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import Foundation
import UIKit

class GenresViewModel {
    
    // MARK: - Callbacks
    var onGenreUpdated: (()->Void)?
    
    // MARK: - Variables
    private(set) var allGenres: [Genre] = [] {
        didSet {
            self.onGenreUpdated?()
        }
    }
    
    private(set) var filteredGenres: [Genre] = []
    
    // MARK: - Initializer
    init() {
        self.fetchCoins()
        print("fetch genres model init")
    }
    
    //refactor
    public func fetchCoins() {
        let apiService = APIService()
        apiService.fetchGenres(apiKey: Constants.API_KEY) { result in
            switch result {
            case .success(let genres):
                print("Fetched genres: \(genres)")
                self.allGenres = genres
            case .failure(let error):
                print("Error fetching genres: \(error)")
            }
        }
    }
}

// MARK: - Search
extension GenresViewModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredGenres = allGenres
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onGenreUpdated?(); return }
            
            self.filteredGenres = self.filteredGenres.filter({ $0.name.lowercased().contains(searchText) })
        }
        self.onGenreUpdated?()
    }
}
