//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol LoginUseCases {
    
    func login(parameter: LoginRequestModel) -> Observable<ResponseModel<LoginResponseModel>>
}

class LoginUseCase: LoginUseCases {
    
    private var network: Network<ResponseModel<LoginResponseModel>>?

    init() {
    }
    
    func login(parameter: LoginRequestModel) -> Observable<ResponseModel<LoginResponseModel>> {
        let service = NetworkService.login(parameter: parameter)
        network = Network(networkService: service)
        return (network?.getDataWithRawBody())!
    }
}

final class LoginViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let useCase = LoginUseCase()
    private let router: LoginRouter

    init(router: LoginRouter) {
        self.router = router
    }
    
    deinit {
        print("\(self) dealloc")
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let emailTracker = ErrorTracker()
        let passwordTracker = ErrorTracker()
        
        let data = Driver
            .combineLatest(input.email, input.password) { (email, password) -> LoginRequestModel in
                return LoginRequestModel(email: email, password: password) }
        
        let loginAccount = input.loginTrigger.withLatestFrom(data).filter({ data in
            if !self.validatePattern(text: data.email) {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email not valid"])
                emailTracker.onError(error)
                return false
            } else if !self.validateLength(text: data.password, size: (6, 15)) {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password not valid"])
                passwordTracker.onError(error)
                return false
            }
            return true
        }).flatMapLatest({ result in
            return self.useCase.login(parameter: result).trackError(errorTracker).trackActivity(activityIndicator).asDriverOnErrorJustComplete()
        }).do(onNext: { result in
            if let user = result.data.user {
                self.router.routeToAccount(user: user)
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: result.errorMessage])
                errorTracker.onError(error)
            }
        })
        
        let dismiss = input.closeTrigger.asDriver().do(onNext: {
            self.router.dismiss()
        })
        
        let activity = activityIndicator.asDriver()
        
        return Output(user: loginAccount, error: errorTracker.asDriver(), emailValidation: emailTracker.asDriver(), passwordValidation: passwordTracker.asDriver(), dismiss: dismiss, hud: activity)
    }
    
    func validatePattern(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func validateLength(text: String, size: (min: Int, max: Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}

extension LoginViewModel {
    
    struct Input {
        
        let loginTrigger: Driver<Void>
        let closeTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }

    struct Output {
        
        let user: Driver<ResponseModel<LoginResponseModel>>
        let error: Driver<Error>
        let emailValidation: Driver<Error>
        let passwordValidation: Driver<Error>
        let dismiss: Driver<Void>
        let hud: Driver<Bool>
    }
}
