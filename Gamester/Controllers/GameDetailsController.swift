//
//  GameDetailsController.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import UIKit
import SDWebImage
import SwiftyBeaver

class GameDetailsController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: GameDetailsViewModel
    let log = SwiftyBeaver.self
    
    // MARK: - UI Components
        
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releasedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textColor = .secondaryLabel
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let metacriticLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(_ viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("\(type(of: self)): viewDidLoad() called")
        setupUI()
        self.viewModel.onDetailsUpdated = { [weak self] in
           DispatchQueue.main.async {
               self?.nameLabel.text = self?.viewModel.nameLabel
               self?.releasedLabel.text = self?.viewModel.releasedLabel
               self?.ratingLabel.text = self?.viewModel.ratingLabel
               self?.gameImageView.sd_setImage(with: URL(string: self?.viewModel.image ?? "" ))
               self?.topRatingLabel.text = self?.viewModel.topRatingLabel
               self?.publisherLabel.text = self?.viewModel.publisherLabel
               self?.metacriticLabel.text = self?.viewModel.metacriticLabel
               self?.descriptionTextView.text = self?.viewModel.descriptionLabel
           }
       }
        
        self.viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = self.viewModel.game?.name ?? ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gameImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(releasedLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(topRatingLabel)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(metacriticLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameImageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            releasedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            releasedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releasedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: releasedLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
            topRatingLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            topRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            publisherLabel.topAnchor.constraint(equalTo: topRatingLabel.bottomAnchor, constant: 10),
            publisherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            publisherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            metacriticLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 10),
            metacriticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            metacriticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
        ])
    }

}
