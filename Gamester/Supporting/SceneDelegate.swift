//
//  SceneDelegate.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit
import SDWebImage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if let genre = UserDefaultsService.shared.getSelectedGenre() {
            print("Selected genre: \(genre)")
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: GamesController(GamesViewModel()))
            self.window = window
            self.window?.makeKeyAndVisible()
        } else {
            print("No genre selected")
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: GenresController())
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }

}

