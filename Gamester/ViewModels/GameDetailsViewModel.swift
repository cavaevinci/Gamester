//
//  GameDetailsViewModel.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GameDetailsViewModel {
    
    //var onImageLoaded: ((UIImage?) -> Void)?
    
    // MARK: Variables
    let game: Game
    
    // MARK: Initializer
    init(_ game: Game) {
        self.game = game
       // self.loadImage()
    }
    
    /*private func loadImage() {
        DispatchQueue.global().async {
            if let mockURL = self.game.mockImg,
             let imageData = try? Data(contentsOf: mockURL),
               let image = UIImage(data: imageData) {
                self.onImageLoaded!(image)
            }
        }
    }*/
    
    // MARK: Computed Properties
    var nameLabel: String {
        return self.game.name
    }
    
    var releasedLabel: String {
        return self.game.released
    }
    
    var ratingLabel: String {
        return String(self.game.rating)
    }
    
    var playTimeLabel: String {
        return String(self.game.playtime)
    }
    
}
