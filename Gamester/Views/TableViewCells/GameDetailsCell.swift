// GameDetailsCell.swift

import UIKit
import SDWebImage

class GameDetailsCell: UITableViewCell {
    
    static let identifier = "GameDetailsCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let gameName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        return label
    }()
    
    private var gameDescription: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with game: Game) {
        gameName.text = game.name
        if let imageURL = URL(string: game.imageBackground ?? "") {
            gameImage.sd_setImage(with: imageURL)
        }
        self.gameDescription.text = game.description
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(gameImage)
        stackView.addArrangedSubview(gameName)
        stackView.addArrangedSubview(gameDescription)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            gameImage.topAnchor.constraint(equalTo: stackView.topAnchor),
            gameImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            gameImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            gameImage.heightAnchor.constraint(equalToConstant: 250),

            gameName.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 8),
            gameName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            gameName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            gameDescription.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 8),
            gameDescription.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            gameDescription.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            gameDescription.bottomAnchor.constraint(lessThanOrEqualTo: stackView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameName.text = nil
        gameImage.image = nil
    }
}
