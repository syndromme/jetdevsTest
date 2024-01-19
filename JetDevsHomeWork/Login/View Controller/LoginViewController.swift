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
        setupEmailField()
        setupPasswordField()
        bindViewModel()
    }
    
// MARK: - UI
    private func setupEmailField() {
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
    }
    
    private func setupPasswordField() {
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
    }
    
// MARK: - ViewModel
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            loginTrigger: loginButton.rx.tap.asDriver(),
            closeTrigger: dismissButton.rx.tap.asDriver(),
            email: emailTextField.textField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.textField.rx.text.orEmpty.asDriver()
        )
        
        self.viewModel = LoginViewModel(router: self.router!, input: input)
        self.viewModel?.emailValidation.bind(to: emailTextField.rx.validationResult).disposed(by: disposeBag)
        self.viewModel?.passwordValidation.bind(to: passwordTextField.rx.validationResult).disposed(by: disposeBag)
        self.viewModel?.errorTracker.drive(errorResponse).disposed(by: disposeBag)
        self.viewModel?.activityIndicator.drive(progressBinding).disposed(by: disposeBag)
        self.viewModel?.loginTrigger.drive(onNext: { result in
            guard let user = result.data.user else {
                self.showAlert(result.errorMessage)
                return
            }
            self.router?.routeToAccount(user: user)
        }, onCompleted: {
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        self.viewModel?.endEditing.drive(onNext: { _ in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
// MARK: - Binder
    

// MARK: - Custom
}

extension UIViewController {
    var errorResponse: Binder<Error> {
        return Binder(self, binding: {(viewController, error) in
            viewController.showAlert(error.localizedDescription)
        })
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
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss",
                                   style: UIAlertAction.Style.cancel,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
