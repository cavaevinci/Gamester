//
//  GenresController.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit
import SnapKit

protocol GenresControllerDelegate {
    func refreshGenres()
}

class GenresController: UIViewController {
    
    // MARK: Variables
    internal let viewModel: GenresViewModel
    var delegate: GenresControllerDelegate?
    
    // MARK: UI Components
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor(hex: "#101118")
        tv.register(GenreCell.self, forCellReuseIdentifier: GenreCell.identifier)
        return tv
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)

    init(_ viewModel: GenresViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        self.setupUI()
        self.setupNavigationBar()
        
        self.viewModel.onGenreUpdated = { [weak self] in
           DispatchQueue.main.async {
               guard let self = self else { return }
               self.tableView.reloadData()
           }
       }
    }
        
    // MARK: UI Setup
    private func setupUI() {
        self.navigationItem.title = "Genres"
        self.view.addSubview(tableView)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let gearIcon = UIImage(systemName: "checkmark")
        let settingsButton = UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(confirmSelectedGenres))
        navigationItem.rightBarButtonItem = settingsButton
        
        // If initial run of app,dont add back button,so user must select genre to continue
        if !(self.navigationController?.previousViewControllerInStack()?.isKind(of: GamesController.self) ?? false) {
            let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func confirmSelectedGenres() {
        if !viewModel.selectedGenres.isEmpty {
            self.handleGenreSelection()
        } else {
            self.showWarning()
        }
    }
    
    private func handleGenreSelection() {
        viewModel.userDefaultsService.saveSelectedGenres(viewModel.selectedGenres)
        if ((self.navigationController?.previousViewControllerInStack()?.isKind(of: GamesController.self)) != nil) {
          delegate?.refreshGenres()
          self.navigationController?.popViewController(animated: true)
        } else {
          let vm = GamesViewModel(apiService: self.viewModel.apiService, userDefaultsService: self.viewModel.userDefaultsService)
          let vc = GamesController(vm)
          self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showWarning() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Please select at least 1 game genre", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
}

// MARK: - TableView DataSource and Delegate
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
      return self.viewModel.cellHeight
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
