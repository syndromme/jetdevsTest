//
//  AccountRouter.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import UIKit

protocol AccountRouterLogic {
    
    func routeToLogin()
    
}

class AccountRouter: AccountRouterLogic {
    
    private let navigationController: UINavigationController
    private let viewController: UIViewController
    
    init(navigationController: UINavigationController, viewController: UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        destinationVC.router = LoginRouter(navigationController: self.navigationController, viewController: destinationVC)
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.modalTransitionStyle = .coverVertical
        self.viewController.present(destinationVC, animated: true)
    }
    
}
