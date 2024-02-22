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
    var onError: ((String) -> Void)?
    
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
        return "\("Release date : ") \(self.game?.released.formatDate() ?? "N/A")"
    }
    
    var ratingLabel: String {
        return "\("Rating : ") \(self.game?.rating ?? 0) / 5"
    }
    
    var websiteLabel: String {
        return "\("Website : ") \(self.game?.website ?? "N/A")"
    }
    
    var topRatingLabel: String {
        return "\("Top Rating : ") \(self.game?.topRating ?? 0)"
    }
    
    var publisherLabel: String {
        return "\("Publisher : ") \(self.game?.publishers?.first?.name ?? "N/A")"
    }
    
    var descriptionLabel: String {
        return "\(self.game?.description ?? "N/A")"
    }
    
    var metacriticLabel: String {
        return "\("Metacritic Score : ") \(self.game?.metacritic ?? 0)"
    }
    
}
