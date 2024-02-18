//
//  GameDetailsViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GameDetailsViewModel {
    
    // MARK: - Callbacks
    var onDetailsUpdated: (()->Void)?
    
    // MARK: Variables
    private(set) var game: Game? {
        didSet {
            self.onDetailsUpdated?()
        }
    }
    let gameID: Int
    
    // MARK: Initializer
    init(_ id: Int) {
        self.gameID = id
        self.fetchGameDetails()
    }
    
    public func fetchGameDetails() {
        let apiService = APIService()
        apiService.fetchGameDetails(apiKey: Constants.API_KEY, gameID: self.gameID) { result in
            switch result {
            case .success(let details):
                print("Fetched details: \(details)")
                self.game = details
            case .failure(let error):
                print("Error fetching details: \(error)")
            }
        }
    }
    
    // MARK: Computed Properties
    var nameLabel: String {
        return self.game?.name ?? ""
    }
    
    var image: String {
        return self.game?.imageBackground ?? ""
    }
    
    var releasedLabel: String {
        return self.game?.released ?? "XXX"
    }
    
    var ratingLabel: String {
        return "\(self.game?.rating ?? 1.0)"
    }
    
    var playTimeLabel: String {
        return "\(self.game?.playTime ?? 1)"
    }
    
    var websiteLabel: String {
        return self.game?.website ?? ""
    }
    
}
