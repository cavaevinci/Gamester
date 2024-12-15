import UIKit
import SnapKit

class SettingsController: UIViewController {
    
    var genresViewController: GenresController?
    var platformsViewController: PlatformsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        self.view.backgroundColor = .systemBackground
        
        // Set up stack view to arrange genres and platforms
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)  // Corrected top constraint
            make.left.right.bottom.equalToSuperview()
        }
        
        // Set up Genres section
        let genresContainer = UIView()
        stackView.addArrangedSubview(genresContainer)
        
        let genresLabel = UILabel()
        genresLabel.text = "Genres"
        genresLabel.font = UIFont.boldSystemFont(ofSize: 20)
        genresLabel.textAlignment = .center
        genresLabel.textColor = .systemBlue
        genresContainer.addSubview(genresLabel)
        
        genresLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        // Set up genres view controller
        let genresVC = GenresController(GenresViewModel(userDefaultsService: LocalStorageService(), apiService: APIService()))
        addChild(genresVC)
        genresContainer.addSubview(genresVC.view)
        genresVC.didMove(toParent: self)
        
        genresVC.view.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        // Set up Platforms section
        let platformsContainer = UIView()
        stackView.addArrangedSubview(platformsContainer)
        
        let platformsLabel = UILabel()
        platformsLabel.text = "Platforms"
        platformsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        platformsLabel.textAlignment = .center
        platformsLabel.textColor = .systemBlue
        platformsContainer.addSubview(platformsLabel)
        
        platformsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        // Set up platforms view controller
        let platformsVC = PlatformsController(PlatformsViewModel(userDefaultsService: LocalStorageService(), apiService: APIService()))
        addChild(platformsVC)
        platformsContainer.addSubview(platformsVC.view)
        platformsVC.didMove(toParent: self)
        
        platformsVC.view.snp.makeConstraints { make in
            make.top.equalTo(platformsLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    @objc func saveSettings() {
        // Example: Saving genres and platforms to UserDefaults
        let selectedGenres = genresViewController?.selectedGenres ?? []
        let selectedPlatforms = platformsViewController?.selectedPlatforms ?? []
        
        // Save the selections to UserDefaults or another data storage
        UserDefaults.standard.set(selectedGenres, forKey: "selectedGenres")
        UserDefaults.standard.set(selectedPlatforms, forKey: "selectedPlatforms")
    }

}
