import SnapKit
import UIKit

class SettingsController: UIViewController {
    
    internal let viewModel: SettingsViewModel
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor(hex: "#101118")
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return tv
    }()
    
    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        setupUI()
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
    
}

// MARK: - UITableViewDataSource
extension SettingsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
            fatalError("Unable to dequeue SettingsCell in SettingsController")
        }
        
        switch viewModel.settingsOptions[indexPath.row] {
        case .genre:
            cell.configure(with: "Select Genre")
        case .platform:
            cell.configure(with: "Select Platform")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsController: UITableViewDelegate {
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userDefaultsService = LocalStorageService()
        let apiService = APIService()
        // Navigate to the appropriate screen based on the selection
        switch viewModel.settingsOptions[indexPath.row] {
        case .genre:
            let vm = GenresViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
            let vc = GenresController(vm)
            navigationController?.pushViewController(vc, animated: true)
        case .platform:
            let vm = PlatformsViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
            let vc = PlatformsController(vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
