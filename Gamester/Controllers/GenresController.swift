//
//  GenresController.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit

class GenresController: UIViewController {
    
    // MARK: Variables
    private let viewModel: GenresViewModel
    
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
        self.setupSearchController()
        self.setupUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel.onGenreUpdated = { [weak self] in
           DispatchQueue.main.async {
               self?.tableView.reloadData()
           }
       }
    }
    
    init(_ viewModel: GenresViewModel = GenresViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: UI Setup
    private func setupUI() {
        self.navigationItem.title = "Gamester"
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
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
        print("Search bar button called!")
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
          cell.configure(with: genre)
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 88
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.tableView.deselectRow(at: indexPath, animated: true)
          
          let inSearchMode = self.viewModel.inSearchMode(searchController)
          
          let genre = inSearchMode ? self.viewModel.filteredGenres[indexPath.row] : self.viewModel.allGenres[indexPath.row]
          print(" selected genre id ---", genre.id)
          let vm = GamesViewModel.init(genre.id)
          let vc = GamesController(vm)
          self.navigationController?.pushViewController(vc, animated: true)
          print(" RADIM NAVIGACIJU--")
      }

}

