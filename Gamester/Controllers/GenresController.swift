//
//  GenresController.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit
import SwiftyBeaver

protocol GenresControllerDelegate {
    func refreshGenres()
}

class GenresController: UIViewController {
    
    // MARK: Variables
    private let viewModel: GenresViewModel
    var delegate: GenresControllerDelegate?
    let log = SwiftyBeaver.self
    
    // MARK: UI Components
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(GenreCell.self, forCellReuseIdentifier: GenreCell.identifier)
        return tv
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("\(type(of: self)): viewDidLoad() called")
        self.setupSearchController()
        self.setupUI()
        self.setupNavigationBar()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel.onGenreUpdated = { [weak self] in
           DispatchQueue.main.async {
               self?.tableView.reloadData()
           }
       }
    }
    
    init(_ viewModel: GenresViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: UI Setup
    private func setupUI() {
        self.navigationItem.title = "Genres"
        self.view.backgroundColor = .black
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func setupNavigationBar() {
        let gearIcon = UIImage(systemName: "checkmark")
        let settingsButton = UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(finishedSelectingGenres))
        navigationItem.rightBarButtonItem = settingsButton
        
        if ((self.navigationController?.previousViewControllerInStack()?.isKind(of: GamesController.self)) != nil) {
        } else {
            let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func finishedSelectingGenres() {
        if !viewModel.selectedGenres.isEmpty {
            viewModel.userDefaultsService.saveSelectedGenres(viewModel.selectedGenres)
            if ((self.navigationController?.previousViewControllerInStack()?.isKind(of: GamesController.self)) != nil) {
              delegate?.refreshGenres()
              self.navigationController?.popViewController(animated: true)
            } else {
              let vm = GamesViewModel(apiService: self.viewModel.apiService, userDefaultsService: self.viewModel.userDefaultsService)
              let vc = GamesController(vm)
              self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: "Please select at least 1 game genre", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
extension GenresController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// MARK: TableView Functions
extension GenresController: UITableViewDelegate, UITableViewDataSource {
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          let inSearchMode = self.viewModel.inSearchMode(searchController)
          return inSearchMode ? self.viewModel.filteredGenres.count : self.viewModel.allGenres.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
              fatalError("Unable to dequeue GenreCell in GenresController")
          }
          
          let inSearchMode = self.viewModel.inSearchMode(searchController)
          
          let genre = inSearchMode ? self.viewModel.filteredGenres[indexPath.row] : self.viewModel.allGenres[indexPath.row]
          let isSelected = viewModel.selectedGenres.contains(genre)
          cell.configure(with: genre, isSelected: isSelected)
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 130
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          tableView.deselectRow(at: indexPath, animated: true)
          let inSearchMode = self.viewModel.inSearchMode(searchController)
          let genre = inSearchMode ? self.viewModel.filteredGenres[indexPath.row] : self.viewModel.allGenres[indexPath.row]
          
          let selectedGenre = genre
          if let index = viewModel.selectedGenres.firstIndex(where: { $0 == selectedGenre }) {
              viewModel.selectedGenres.remove(at: index)
          } else {
              viewModel.selectedGenres.append(selectedGenre)
          }
          
          tableView.reloadRows(at: [indexPath], with: .automatic)
      }
}
