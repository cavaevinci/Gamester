//
//  GameCell.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit
import SnapKit
import SDWebImage

class GameCell: UICollectionViewCell {
    
    static let identifier = "GameCell"
    
    private lazy var gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var gameName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
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
        self.gameName.text = game.name
        self.gameImage.sd_setImage(with: URL(string: game.imageBackground ?? "" ))
    }
    
    private func setupUI() {
        contentView.addSubview(gameImage)
        contentView.addSubview(gameName)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        gameImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(gameImage.snp.width)
        }
        
        gameName.snp.makeConstraints { make in
            make.top.equalTo(gameImage.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gameName.text = nil
        self.gameImage.image = nil
    }
}
