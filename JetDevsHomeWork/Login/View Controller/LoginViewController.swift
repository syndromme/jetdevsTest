//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    var router: LoginRouter?
    private var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [.font: UIFont.latoRegularFont(size: 16),
                                                                               .foregroundColor: UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)])
        emailTextField.floatingText = "Email"
        emailTextField.inputFont = UIFont.latoRegularFont(size: 16)
        emailTextField.inputColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        emailTextField.keyboardType = .emailAddress
        emailTextField.floatingFont = UIFont.latoSemiBoldFont(size: 12)
        emailTextField.floatingColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        emailTextField.borderColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        emailTextField.errorFont = UIFont.latoRegularFont(size: 14)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [.font: UIFont.latoRegularFont(size: 16),
                                                                               .foregroundColor: UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)])
        passwordTextField.floatingText = "Password"
        passwordTextField.inputFont = UIFont.latoRegularFont(size: 16)
        passwordTextField.inputColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        passwordTextField.floatingFont = UIFont.latoSemiBoldFont(size: 12)
        passwordTextField.floatingColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        passwordTextField.borderColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        passwordTextField.errorFont = UIFont.latoRegularFont(size: 14)
        passwordTextField.isSecure = true
        
        self.viewModel = LoginViewModel(router: self.router!)
        
        let input = LoginViewModel.Input(
            loginTrigger: loginButton.rx.tap.asDriver(),
            closeTrigger: dismissButton.rx.tap.asDriver(),
            email: emailTextField.textField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.textField.rx.text.orEmpty.asDriver()
        )

        let output = viewModel!.transform(input: input)
        [output.user.drive(),
         output.error.drive(errorBinding),
         output.emailValidation.drive(validationEmailBinding),
         output.passwordValidation.drive(validationPasswordBinding),
         output.dismiss.drive(),
         output.hud.drive(progressBinding)
        ].forEach({$0.disposed(by: disposeBag)})
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: {(viewController, error) in
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        })
    }
    
    var validationEmailBinding: Binder<Error> {
        return Binder(self) { _, error in
            self.emailTextField.showError(error.localizedDescription)
        }
    }
    
    var validationPasswordBinding: Binder<Error> {
        return Binder(self) { _, error in
            self.passwordTextField.showError(error.localizedDescription)
        }
    }
    
    var progressBinding: Binder<Bool> {
        return Binder(self) { _, value in
            if value {
                ProgressHUD.show("Authentication...")
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
}
