//
//  UINavigationController+Extension.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import UIKit

extension UINavigationController {
    func viewControllerBeforeNavigation() -> UIViewController? {
        guard let topIndex = viewControllers.firstIndex(of: topViewController!) else {
            return nil
        }
        
        let previousIndex = topIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        print("VC----", viewControllers[previousIndex].nibName)
        return viewControllers[previousIndex]
    }
}
