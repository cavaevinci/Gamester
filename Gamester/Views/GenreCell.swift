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
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        return iv
    }()
    
    private var genreName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    public func configure(with genre: Genre) {
        self.genre = genre
        self.genreName.text = genre.name
        self.genreImage.sd_setImage(with: URL(string: genre.imageBackground))
    }
    
    private func setupUI() {
        self.addSubview(genreImage)
        self.addSubview(genreName)
        
        genreImage.translatesAutoresizingMaskIntoConstraints = false
        genreName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            genreImage.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            genreImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            genreImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            genreName.leadingAnchor.constraint(equalTo: genreImage.trailingAnchor, constant: 16),
            genreName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: PrepareForReuse
       override func prepareForReuse() {
           super.prepareForReuse()
           self.genreName.text = nil
           self.genreImage.image = nil
       }
    
}
