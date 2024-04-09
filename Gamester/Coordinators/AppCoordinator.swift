//
//  AppCoordinator.swift
//  Gamester
//
//  Created by Nino on 09.04.2024..
//

import UIKit
import SwiftyBeaver

class AppCoordinator: Coordinator {
    
    let log = SwiftyBeaver.self
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController

    init(navCon : UINavigationController) {
        self.navigationController = navCon
    }
    
    func start() {
        print("START")
        log.debug("\(type(of: self)): Coordinator Start")
    }
}
