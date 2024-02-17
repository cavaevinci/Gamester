//
//  GameCell.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit
import SDWebImage

class GameCell: UICollectionViewCell {
    
    static let identifier = "GameCell"
    private(set) var game: Game!
    
    private var gameImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        return iv
    }()
    
    private var gameName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with game: Game) {
        self.game = game
        self.gameName.text = game.name
        self.gameImage.sd_setImage(with: URL(string: "https://media.rawg.io/media/games/713/713269608dc8f2f40f5a670a14b2de94.jpg"))
    }
    
    private func setupUI() {
        self.addSubview(gameImage)
        self.addSubview(gameName)
        
        gameName.numberOfLines = 0
        gameName.lineBreakMode = .byWordWrapping
        
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            gameImage.topAnchor.constraint(equalTo: self.topAnchor),
            gameImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            gameImage.heightAnchor.constraint(equalTo: gameImage.widthAnchor),
            
            gameName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            gameName.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 8),
            gameName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            gameName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gameName.text = nil
        self.gameImage.image = nil
    }
}
