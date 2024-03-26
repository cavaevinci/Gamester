// GameDetailsController.swift

import UIKit
import SwiftyBeaver

class GameDetailsController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: GameDetailsViewModel
    let log = SwiftyBeaver.self
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(GameDetailsCell.self, forCellReuseIdentifier: GameDetailsCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.onDetailsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate

extension GameDetailsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailsCell.identifier, for: indexPath) as? GameDetailsCell else {
            fatalError("Unable to dequeue GameDetailsCell")
        }
        if let game = viewModel.game {
            cell.configure(with: game)
        }
        return cell
    }
}
