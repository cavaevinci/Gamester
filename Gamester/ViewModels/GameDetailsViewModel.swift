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
    
    var releasedLabel: String {
        return self.game?.released ?? "XXX"
    }
    
    var ratingLabel: String {
       // return String(self.game.rating)
        return "RATING LABEL"
    }
    
    var playTimeLabel: String {
        //return String(self.game.playTime)
        return "PLAY TIME LABEL"
    }
    
}
