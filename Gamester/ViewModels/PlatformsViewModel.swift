//
//  PlatformsViewModel.swift
//  Gamester
//
//  Created by Erik Đurkan on 13.12.2024..
//

import UIKit

class PlatformsViewModel {
    // MARK: - Variables
    internal let apiService: APIServiceProtocol
    internal let userDefaultsService: LocalStorageServiceProtocol
    
    private(set) var allPlatforms: [Platform] = [] {
        didSet {
            self.onPlatformsUpdated?()
        }
    }
    
    var selectedPlatforms: [Platform] = [] {
        didSet {
            self.onPlatformsUpdated?()
        }
    }
    
    private(set) var filteredPlatforms: [Platform] = []
    
    
    let cellHeight: CGFloat = 130.0
    
    // MARK: - Callbacks
    var onPlatformsUpdated: (()->Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializer
    init(userDefaultsService: LocalStorageServiceProtocol, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.userDefaultsService = userDefaultsService
        self.fetchPlatformsFromAPI()
    }
    
    public func fetchPlatformsFromAPI() {
        apiService.fetchData(from: .platforms, responseType: PlatformsResponse.self) { [self] result in
            switch result {
            case .success(let platforms):
                self.allPlatforms = platforms.results
                
                print(allPlatforms)
            case .failure(let error):
                self.onError?("Error fetching game details: \(error.localizedDescription)")
            }
        }
    }
    
}

// MARK: - Search
extension PlatformsViewModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredPlatforms = allPlatforms
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onPlatformsUpdated?(); return }
            
            self.filteredPlatforms = self.filteredPlatforms.filter({ $0.name.lowercased().contains(searchText) })
        }
        self.onPlatformsUpdated?()
    }
}
