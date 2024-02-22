//
//  SceneDelegate.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit
import SwiftyBeaver

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let log = SwiftyBeaver.self

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        self.setupSwiftyBeaver()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = makeRootViewController()
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let userDefaultsService = LocalStorageService()
        let apiService = APIService()
        if !userDefaultsService.getSelectedGenres().isEmpty {
            let vm = GamesViewModel(apiService: apiService, userDefaultsService: userDefaultsService)
            return GamesController(vm)
        } else {
            let vm = GenresViewModel(userDefaultsService: userDefaultsService, apiService: apiService)
            return GenresController(vm)
        }
    }
    
    private func setupSwiftyBeaver() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.info("SwiftyBeaver logging configured")
    }
}

