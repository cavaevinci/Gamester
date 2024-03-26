//
//  GameDetailsController.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import UIKit
import SwiftyBeaver

class GameDetailsController: UIViewController {
    
    // MARK: - Properties
    let viewModel: GameDetailsViewModel
    let log = SwiftyBeaver.self
    
    // MARK: - Lifecycle
    init(_ viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: UI Components
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(GameDetailsCell.self, forCellReuseIdentifier: GameDetailsCell.identifier)
        return tv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("\(type(of: self)): viewDidLoad() called")
        setupUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 1000
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.viewModel.onDetailsUpdated = { [weak self] in
           DispatchQueue.main.async {
               self?.tableView.reloadData()
           }
       }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
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
extension GameDetailsController: UITableViewDelegate, UITableViewDataSource {
    
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
  
  /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 130
  }*/
  
}
