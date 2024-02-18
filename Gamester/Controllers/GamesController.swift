//
//  GamesController.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit

class GamesController: UIViewController, GenresControllerDelegate {
    
    func changedGenres() {
        print(" JAVIO GAMES CONTROLLERU DA RELOADAM GENRES---")
        viewModel.fetchGames()
    }
    
    // MARK: Variables
    private let viewModel: GamesViewModel
    
    // MARK: UI Components
    private var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.identifier)
        return collectionView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        self.setupUI()
        self.setupNavigationBar()
        
        self.viewModel.onGamesUpdated = { [weak self] in
           DispatchQueue.main.async {
               self?.collectionView.reloadData()
           }
       }
        
       self.collectionView.delegate = self
       self.collectionView.dataSource = self
    }
    
    init(_ viewModel: GamesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    private func setupUI() {
        self.navigationItem.title = "Games"
        self.view.backgroundColor = .systemBlue
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func setupNavigationBar() {
        // Create a gear icon system item
        let gearIcon = UIImage(systemName: "gear")
        
        // Create a UIBarButtonItem with the gear icon
        let settingsButton = UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        // Set the button as the right bar button item
        navigationItem.rightBarButtonItem = settingsButton
        
        // Create a custom back button with an empty action
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
        
    @objc func settingsButtonTapped() {
        // Handle settings button tap
        // Implement your settings functionality here
        print("Settings button tapped!")
        let vm = GenresViewModel()
        let vc = GenresController(vm)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - Search Controller Functions
extension GamesController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar button called!")
    }
}

// MARK: - CollectionVIew Functions
extension GamesController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredGames.count : self.viewModel.allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as? GameCell else {
            fatalError("Unable to dequeue GameCell in GamesController")
        }
        
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        
        let game = inSearchMode ? self.viewModel.filteredGames[indexPath.row] : self.viewModel.allGames[indexPath.row]
        cell.configure(with: game)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        
        let game = inSearchMode ? self.viewModel.filteredGames[indexPath.row] : self.viewModel.allGames[indexPath.row]
        let vm = GameDetailsViewModel(game.id)
        let vc = GameDetailsController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension GamesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width / 3) - 8
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

