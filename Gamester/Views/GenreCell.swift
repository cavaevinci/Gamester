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
        iv.layer.cornerRadius = 8 // Rounded corners for a modern look
        return iv
    }()
    
    private var genreName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold) // Slightly smaller font size for the name
        label.numberOfLines = 2 // Allow name to wrap onto multiple lines if needed
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
        contentView.addSubview(genreImage)
        contentView.addSubview(genreName)
        
        genreImage.translatesAutoresizingMaskIntoConstraints = false
        genreName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12), // Add some top padding
            genreImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // Add some leading padding
            genreImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12), // Add some bottom padding
            genreImage.widthAnchor.constraint(equalTo: genreImage.heightAnchor), // Ensure image is square
            
            genreName.leadingAnchor.constraint(equalTo: genreImage.trailingAnchor, constant: 16), // Add some spacing between image and name
            genreName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Add trailing padding
            genreName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center name vertically
        ])
    }
    
    // MARK: PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.genreName.text = nil
        self.genreImage.image = nil
    }
}
