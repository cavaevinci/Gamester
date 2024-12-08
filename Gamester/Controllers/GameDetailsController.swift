// GameDetailsController.swift

import UIKit

class GameDetailsController: UIViewController {
    
    // MARK: - Variables
    let viewModel: GameDetailsViewModel
    
    // MARK: UI Components
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(GameDetailsCell.self, forCellReuseIdentifier: GameDetailsCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
        
        self.viewModel.onDetailsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}

// MARK: - TableView DataSource and Delegate
extension GameDetailsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailsCell.identifier, for: indexPath) as? GameDetailsCell else {
            fatalError("Unable to dequeue GameDetailsCell in GameDetailsController")
        }
        if let game = viewModel.game {
            cell.configure(with: game)
        }
        return cell
    }
}
