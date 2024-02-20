//
//  GameDetailsViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GameDetailsViewModel {
    
    // MARK: Variables
    internal let apiService: APIServiceProtocol
    let gameID: Int
    
    private(set) var game: Game? {
        didSet {
            self.onDetailsUpdated?()
        }
    }
    
    // MARK: - Callbacks
    var onDetailsUpdated: (()->Void)?
    var onError: ((String) -> Void)? // Callback for error handling
    
    // MARK: Initializer
    init(_ id: Int, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.gameID = id
        self.fetchGameDetails()
    }
    
    public func fetchGameDetails() {
        apiService.fetchData(from: .gameDetails(gameID: self.gameID), responseType: Game.self) { result in
            switch result {
            case .success(let game):
                self.game = game
            case .failure(let error):
                // Pass the error message to the onError callback for handling in the view controller
                self.onError?("Error fetching game details: \(error.localizedDescription)")
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
