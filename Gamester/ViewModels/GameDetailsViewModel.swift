//
//  GameDetailsViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GameDetailsViewModel {
    
    // MARK: Variables
    private let apiService: APIServiceProtocol
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
    
}
