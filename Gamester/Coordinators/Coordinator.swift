//
//  Coordinator.swift
//  Gamester
//
//  Created by Nino on 09.04.2024..
//

import UIKit

protocol Coordinator {    
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
