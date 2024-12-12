// GameDetailsCell.swift

import UIKit
import SnapKit
import SDWebImage

class GameDetailsCell: UITableViewCell {
    
    static let identifier = "GameDetailsCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var gameName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var gameDescription: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var topRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var metacriticRatingLabel: UILabel = {
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
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview().offset(-12)
        }
        
        gameImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(420)
        }
        
        gameName.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gameImage.snp.bottom).offset(8)
        }
        
        gameDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gameName.snp.bottom).offset(8)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gameDescription.snp.bottom).offset(8)
        }
        
        websiteLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(8)
        }
        
        topRatingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(websiteLabel.snp.bottom).offset(8)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topRatingLabel.snp.bottom).offset(8)
        }
        
        metacriticRatingLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(publisherLabel.snp.bottom).offset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameName.text = nil
        gameImage.image = nil
        gameDescription.text = nil
    }
}
