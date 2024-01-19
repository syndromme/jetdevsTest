//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountViewModel {
    
    private let disposeBag = DisposeBag()
    private let router: AccountRouter
    
    private let dbManager = RealmManager<RMUser>()
    var currentUser: Driver<UserModel?> = Driver.empty()
    var logout: Driver<Void> = Driver.empty()
    
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    init(router: AccountRouter, input: Input) {
        self.router = router
        
        var rmuser = input.trigger.flatMapLatest { _ in
            return self.dbManager.queryAll().trackActivity(self.activityIndicator).trackError(self.errorTracker).asDriverOnErrorJustComplete()
        }.flatMapLatest({ users in
            return Driver.just(users.first)
        })
        
        currentUser = rmuser.flatMapLatest({ user in
            return Driver.just(user?.transform())
        }).asDriver()
        
        logout = input.logoutTrigger.withLatestFrom(rmuser).filter({ user in
            return user == nil || !(user?.isInvalidated)!
        }).flatMapLatest({ user in
            return self.dbManager.delete(entity: user!).trackError(self.errorTracker).trackActivity(self.activityIndicator).asDriverOnErrorJustComplete()
        }).asDriver()
        
        _ = input.loginTrigger.drive(onNext: { _ in
            self.router.routeToLogin()
        })
    }
}

extension AccountViewModel {
    
    struct Input {
        var trigger: Driver<Void>
        var loginTrigger: Driver<Void>
        var logoutTrigger: Driver<Void>
    }
}
