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
        self.window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let userDefaultsService = UserDefaultsService()
        let apiService = APIService()
        if userDefaultsService.getSelectedGenre() != nil {
            let vm = GamesViewModel(apiService: apiService)
            return GamesController(vm)
        } else {
            let vm = GenresViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
            return GenresController(vm)
        }
    }
}

