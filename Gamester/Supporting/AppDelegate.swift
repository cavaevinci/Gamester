//
//  AppDelegate.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         FirebaseApp.configure()
        
         window = UIWindow(frame: UIScreen.main.bounds)
         let navigationCon = UINavigationController.init()
         appCoordinator = AppCoordinator(navCon: navigationCon)
         appCoordinator!.start()
         window!.rootViewController = navigationCon
         window!.makeKeyAndVisible()
         return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

