//
//  SceneDelegate.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = makeRootViewController()
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window = window
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .dark
        }
        self.window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if let navigationController = window?.rootViewController as? UINavigationController {
            if let gamesController = navigationController.viewControllers.first as? GamesController {
                gamesController.viewModel.fetchGames()
            } else if let genresController = navigationController.viewControllers.first as? GenresController {
                genresController.viewModel.fetchGenresFromAPI()
            }
        }
    }
    
    private func makeRootViewController() -> UIViewController {
        let userDefaultsService = LocalStorageService()
        let apiService = APIService()
        
        if userDefaultsService.isFirstRun() {
            let vm = PlatformsViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
            return PlatformsController(vm)
        } else {
            let vm = GamesViewModel(apiService: apiService, userDefaultsService: userDefaultsService)
            return GamesController(vm)
        }
    }
    
}
