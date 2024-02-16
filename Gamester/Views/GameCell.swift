//
//  GameCell.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GameCell: UICollectionViewCell {
    
    static let identifier = "GameCell"
    private(set) var game: Game!
    
    private var gameImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "")
        iv.tintColor = .white
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    private var gameName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    public func configure(with game: Game) {
        self.game = game
        self.gameName.text = game.name
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(gameImage)
        self.addSubview(gameName)
        
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gameImage.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            gameImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            gameImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            gameName.leadingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: 16),
            gameName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gameImage.image = nil
    }
}
