//
//  GameDetailsDescriptionViewModel.swift
//  Gamester
//
//  Created by Nino on 23.02.2024..
//

import UIKit

class GameDetailsDescriptionViewModel {
    
    // MARK: Variables
    let description: String?
    
    // MARK: Initializer
    init(_ description: String) {
        self.description = description
    }
    
    // MARK: Computed Properties
    var descriptionLabel: String {
        return "\(self.description ?? "N/A")"
    }
}

