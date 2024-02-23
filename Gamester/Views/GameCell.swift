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
    
    internal var gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    internal var gameName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
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
        self.gameImage.sd_setImage(with: URL(string: game.imageBackground ))
    }
    
    private func setupUI() {
        contentView.addSubview(gameImage)
        contentView.addSubview(gameName)
        gameImage.layer.cornerRadius = 8
        gameImage.layer.masksToBounds = true
        gameName.translatesAutoresizingMaskIntoConstraints = false
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameImage.heightAnchor.constraint(equalTo: gameImage.widthAnchor),
            
            gameName.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 4),
            gameName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            gameName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gameName.text = nil
        self.gameImage.image = nil
    }
}
