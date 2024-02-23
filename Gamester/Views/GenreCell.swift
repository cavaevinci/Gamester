//
//  GenreCell.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit
import SDWebImage

class GenreCell: UITableViewCell {
    
    static let identifier = "GenreCell"
    private(set) var genre: Genre!
    
    private var genreImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private var genreName: UILabel = {
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
            self.contentView.backgroundColor = .systemBlue
        } else {
            self.contentView.backgroundColor = .black
        }
        self.genre = genre
        self.genreName.text = genre.name
        self.genreImage.sd_setImage(with: URL(string: genre.imageBackground))
    }
    
    private func setupUI() {
        contentView.addSubview(genreImage)
        contentView.addSubview(genreName)
        
        genreImage.translatesAutoresizingMaskIntoConstraints = false
        genreName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            genreImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            genreImage.widthAnchor.constraint(equalTo: genreImage.heightAnchor),
            
            genreName.leadingAnchor.constraint(equalTo: genreImage.trailingAnchor, constant: 16),
            genreName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            genreName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) 
        ])
    }
    
    // MARK: PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.genreName.text = nil
        self.genreImage.image = nil
    }
}
