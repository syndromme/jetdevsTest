//
//  LoginRouter.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import UIKit
import RxSwift

protocol LoginRouterLogic {
    
    func routeToAccount(user: UserModel)
    func dismiss()
    
}

class LoginRouter: LoginRouterLogic {
    
    private let navigationController: UINavigationController
    private let viewController: UIViewController
    
    init(navigationController: UINavigationController, viewController: UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    
    func routeToAccount(user: UserModel) {
        guard let destinationVC = self.navigationController.viewControllers.filter({ $0.isKind(of: AccountViewController.self)}).first as? AccountViewController else {
            return
        }
        destinationVC.viewModel = AccountViewModel(user: user)
        self.dismiss()
    }
    
    func dismiss() {
        self.viewController.dismiss(animated: true)
    }
    
}
