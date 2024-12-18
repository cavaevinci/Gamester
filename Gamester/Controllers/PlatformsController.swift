//
//  PlatformsController.swift
//  Gamester
//
//  Created by Erik Đurkan on 13.12.2024..
//

import UIKit
import SnapKit

protocol PlatformsControllerDelegate {
    func refreshPlatforms()
}

class PlatformsController: UIViewController {
    
    internal let viewModel: PlatformsViewModel
    var delegate: PlatformsControllerDelegate?
    
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
    
    init(_ viewModel: PlatformsViewModel) {
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
        
        self.viewModel.onPlatformsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func setupUI() {
        self.view.addSubview(tableView)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Platforms"
        let gearIcon = UIImage(systemName: "checkmark")
        let settingsButton = UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(confirmSelectedPlatforms))
        navigationItem.rightBarButtonItem = settingsButton
        
        // Check if the previous view controller is SettingsViewController
        if let previousVC = navigationController?.viewControllers.dropLast().last as? SettingsController {
            // Add a custom back button if the previous view controller is SettingsViewController
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func backButtonTapped() {
        // Go back to the previous view controller
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmSelectedPlatforms() {
        if !viewModel.selectedPlatforms.isEmpty {
            let saveResult = viewModel.userDefaultsService.save(viewModel.selectedPlatforms, forKey: .selectedPlatforms)
            switch saveResult {
            case .success:
                print("Platforms saved successfully!")
            case .failure(let error):
                print("Failed to save platforms: \(error)")
            }
            
            let vm = GenresViewModel(userDefaultsService: self.viewModel.userDefaultsService, apiService: self.viewModel.apiService)
            let vc = GenresController(vm)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showWarning()
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
    
    private func showWarning() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Please select at least 1 platform", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
// MARK: - Search Controller Functions
extension PlatformsController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}
// MARK: - TableView DataSource and Delegate
extension PlatformsController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let inSearchMode = self.viewModel.inSearchMode(searchController)
      return inSearchMode ? self.viewModel.filteredPlatforms.count : self.viewModel.allPlatforms.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
          fatalError("Unable to dequeue GenreCell in GenresController")
      }
      
      let inSearchMode = self.viewModel.inSearchMode(searchController)
      
      let genre = inSearchMode ? self.viewModel.filteredPlatforms[indexPath.row] : self.viewModel.allPlatforms[indexPath.row]
      let isSelected = viewModel.selectedPlatforms.contains(genre)
      cell.configurePlatform(with: genre, isSelected: isSelected)
      return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return self.viewModel.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      tableView.deselectRow(at: indexPath, animated: true)
      let inSearchMode = self.viewModel.inSearchMode(searchController)
      let genre = inSearchMode ? self.viewModel.filteredPlatforms[indexPath.row] : self.viewModel.allPlatforms[indexPath.row]
      
      let selectedGenre = genre
      if let index = viewModel.selectedPlatforms.firstIndex(where: { $0 == selectedGenre }) {
          viewModel.selectedPlatforms.remove(at: index)
      } else {
          viewModel.selectedPlatforms.append(selectedGenre)
      }
      
      tableView.reloadRows(at: [indexPath], with: .automatic)
  }
}
