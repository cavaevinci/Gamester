// GameDetailsCell.swift
// Gamester
//
// Created by Nino on 26.03.2024..
//

import UIKit
import SDWebImage

class GameDetailsCell: UITableViewCell {

  static let identifier = "GameDetailsCell"
  private(set) var game: Game!

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4  // Adjust spacing as needed
    stackView.distribution = .fillProportionally
    return stackView
  }()

  private var gameImage: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 8
    return iv
  }()

  private var gameName: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.numberOfLines = 3
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(with game: Game) {
    self.game = game
    self.gameName.text = game.name
    self.gameImage.sd_setImage(with: URL(string: game.imageBackground ?? ""))
  }

  private func setupUI() {
    contentView.backgroundColor = .white

    stackView.addArrangedSubview(gameImage)
    stackView.addArrangedSubview(gameName)

    contentView.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    let imageHeightConstraint = gameImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
    imageHeightConstraint.priority = .defaultHigh
    
    NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

        imageHeightConstraint,

        gameName.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.5)
    ])
  }

  // MARK: PrepareForReuse
  override func prepareForReuse() {
    super.prepareForReuse()
    self.gameName.text = nil
    self.gameImage.image = nil
  }

}
