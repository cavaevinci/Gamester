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
    //var onErrorMessage: ((CoinServiceError)->Void)?
    
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
    }
    
    public func fetchCoins() {
        print(" fetch coins---")
        self.allGenres.append(Genre(name: "ww", image_background: "ff"))
        self.allGenres.append(Genre(name: "wwfff", image_background: "ff"))
        self.allGenres.append(Genre(name: "wwggrsgr", image_background: "ff"))
        self.allGenres.append(Genre(name: "wwdrhdth", image_background: "ff"))
        self.allGenres.append(Genre(name: "wwdthdth", image_background: "ff"))
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
