//
//  GenresViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import Foundation
import UIKit

class GenresViewModel {
    
    // MARK: - Variables
    internal let apiService: APIServiceProtocol
    internal let userDefaultsService: LocalStorageServiceProtocol
    
    private(set) var allGenres: [Genre] = [] {
        didSet {
            self.onGenreUpdated?()
        }
    }
    
    private(set) var filteredGenres: [Genre] = []
    
    // MARK: - Callbacks
    var onGenreUpdated: (()->Void)?
    
    // MARK: - Initializer
    init(userDefaultsService: LocalStorageServiceProtocol, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.userDefaultsService = userDefaultsService
        self.fetchGenres()
    }
    
    public func fetchGenres() {
        apiService.fetchData(from: .genres, responseType: GenresResponse.self) { result in
            switch result {
            case .success(let genres):
                self.allGenres = genres.results
            case .failure(let error):
                print("Error fetching details: \(error)")
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
