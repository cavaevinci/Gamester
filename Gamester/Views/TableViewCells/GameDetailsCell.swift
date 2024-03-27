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
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        return label
    }()
    
    private let topRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let metacriticRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        gameDescription.text = game.description
        releaseDateLabel.text = "Release Date: \(game.released ?? "")"
        ratingLabel.text = "Rating: \(game.rating)"
        websiteLabel.text = "\(game.website ?? "")"
        topRatingLabel.text = "Top Rating: \(game.topRating)"
        publisherLabel.text = "Publisher: \(game.publishers?.first?.name ?? "")"
        metacriticRatingLabel.text = "Metacritic Rating: \(game.metacritic ?? 1)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleWebsiteTap(_:)))
        websiteLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleWebsiteTap(_ sender: UITapGestureRecognizer) {
        if let websiteURLString = websiteLabel.text,
           let encodedURLString = websiteURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let websiteURL = URL(string: encodedURLString) {
            UIApplication.shared.open(websiteURL)
        }
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(gameImage)
        stackView.addArrangedSubview(gameName)
        stackView.addArrangedSubview(gameDescription)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(websiteLabel)
        stackView.addArrangedSubview(topRatingLabel)
        stackView.addArrangedSubview(publisherLabel)
        stackView.addArrangedSubview(metacriticRatingLabel)

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
            gameImage.heightAnchor.constraint(equalToConstant: 420),

            gameName.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 8),
            gameName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            gameName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            gameDescription.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 8),
            gameDescription.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            gameDescription.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalTo: gameDescription.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            websiteLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            websiteLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            topRatingLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            topRatingLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            topRatingLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            publisherLabel.topAnchor.constraint(equalTo: topRatingLabel.bottomAnchor, constant: 8),
            publisherLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            publisherLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            metacriticRatingLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 8),
            metacriticRatingLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            metacriticRatingLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            metacriticRatingLabel.bottomAnchor.constraint(lessThanOrEqualTo: stackView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameName.text = nil
        gameImage.image = nil
        gameDescription.text = nil
    }
}
