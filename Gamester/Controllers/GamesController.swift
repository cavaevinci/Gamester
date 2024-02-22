//
//  GamesController.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//

import UIKit
import SDWebImage
import SwiftyBeaver

class GamesController: UIViewController, GenresControllerDelegate, PinterestLayoutDelegate {
    
    // MARK: Variables
    private let viewModel: GamesViewModel
    let log = SwiftyBeaver.self
    
    // MARK: UI Components
    private var collectionView: UICollectionView = {
       let layout = PinterestLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.identifier)
        return collectionView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("\(type(of: self)): viewDidLoad() called")
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
       if let layout = collectionView.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
       }
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
        let gearIcon = UIImage(systemName: "gear")
        let settingsButton = UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        navigationItem.rightBarButtonItem = settingsButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    func refreshGenres() {
        viewModel.fetchGames()
    }
        
    @objc func settingsButtonTapped() {
        let userDefaultsService = LocalStorageService()
        let apiService = APIService()
        let vm = GenresViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
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
    }
}

// MARK: - CollectionVIew Functions
extension GamesController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredGames.count : self.viewModel.allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
            //not good,not bad solution
            return CGFloat.random(in: 220...310)
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
        let vm = GameDetailsViewModel(game.id, apiService: self.viewModel.apiService)
        let vc = GameDetailsController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.currentPage += 1
            viewModel.fetchGamesWithSearchText("")
        }
    }
    
}
