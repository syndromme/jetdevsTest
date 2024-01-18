//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class LoginViewModel {
    
    enum LoginService: NetworkService {
        var method: Alamofire.HTTPMethod {
            switch self {
            default:
                return .post
            }
        }
        
        var parameters: Alamofire.Parameters? {
            switch self {
            case .login(let parameters):
                return parameters.dictionary
            }
        }
        
        var path: String {
            switch self {
            case .login:
                return "login"
            }
        }
    
        case login(parameters: LoginRequestModel)
    }
    
    private let disposeBag = DisposeBag()
    private let router: LoginRouter

    var emailValidation: Observable<ValidationResult> = Observable.empty()
    var passwordValidation: Observable<ValidationResult> = Observable.empty()
    var loginTrigger: Driver<ResponseModel<LoginResponseModel>> = Driver.empty()
    var endEditing: Driver<Void> = Driver.empty()
    
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let network: Network<ResponseModel<LoginResponseModel>> = Network()

    init(router: LoginRouter, input: Input) {
        self.router = router
        
        emailValidation = input.email.asObservable().map({ data in
            return self.validateEmail(data)
        })
        
        passwordValidation = input.password.asObservable().map({ data in
            return self.validatePassword(data)
        })
        
        let data = Driver
            .combineLatest(input.email, input.password) { (email, password) -> LoginRequestModel in
                return LoginRequestModel(email: email, password: password) }

        let validations = Observable.combineLatest(emailValidation, passwordValidation).map({ data in
            return data.0 == .valid && data.1 == .valid
        }).asDriverOnErrorJustComplete()
        
        endEditing = input.loginTrigger.asDriver()
        
        loginTrigger = input.loginTrigger.withLatestFrom(validations).filter { isvalid in
            return isvalid
        }.withLatestFrom(data).flatMapLatest { request in
            let service = LoginService.login(parameters: request)
            NetworkManager.shared.service = service
            return self.network.load().trackError(self.errorTracker).trackActivity(self.activityIndicator).asDriverOnErrorJustComplete()
        }
        
        _ = input.closeTrigger.asDriver().do(onNext: { _ in
            self.router.dismiss()
        }).drive().disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) dealloc")
    }

    private func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .empty
        }
        
        if !email.validatePattern(emailRegEx) {
            return .failed(message: "Email not valid")
        }
        
        return .valid
    }
    
    private func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .empty
        }
        
        if !password.validatePattern(passwordRegEx) {
            return .failed(message: "Password not valid")
        }
        
        return .valid
    }
}

extension LoginViewModel {
    
    struct Input {
        
        let loginTrigger: Driver<Void>
        let closeTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }
}
