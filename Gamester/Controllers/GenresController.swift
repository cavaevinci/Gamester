//
//  GenresController.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit

class GenresController: UIViewController {
    
    // MARK: Variables
    private let genres: [Genre] = Genre.getMockArray()
    
    // MARK: UI Components
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(GenreCell.self, forCellReuseIdentifier: GenreCell.identifier)
        return tv
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
}

// MARK: TableView Functions
extension GenresController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
            fatalError("Unable to dequeue GenreCell in GenresController")
        }
        let genre = self.genres[indexPath.row]
        cell.configure(with: genre)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let genre = self.genres[indexPath.row]
        let vm = GameDetailsViewModel(genre.games.first!)
        let vc = GameDetailsController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

