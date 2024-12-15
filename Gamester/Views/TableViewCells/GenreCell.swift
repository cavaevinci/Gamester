//
//  GenreCell.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit
import SnapKit
import SDWebImage

class GenreCell: UITableViewCell {
    
    static let identifier = "GenreCell"
    
    private lazy var genreImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private lazy var genreName: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
     
    public func configure(with genre: Genre, isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .systemGray
        } else {
            self.contentView.backgroundColor = UIColor(hex: "#101118")
        }
        self.genreName.text = genre.name
        self.genreImage.sd_setImage(with: URL(string: genre.imageBackground))
    }
    public func configurePlatform(with platform: Platform, isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .systemGray
        } else {
            self.contentView.backgroundColor = UIColor(hex: "#101118")
        }
        self.genreName.text = platform.name
        self.genreImage.sd_setImage(with: URL(string: platform.imageBackground))
    }
    
    private func setupUI() {
        contentView.addSubview(genreImage)
        contentView.addSubview(genreName)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        genreImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(genreImage.snp.height)
        }
        
        genreName.snp.makeConstraints { make in
            make.leading.equalTo(genreImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.genreName.text = nil
        self.genreImage.image = nil
    }
}
