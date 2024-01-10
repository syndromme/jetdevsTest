//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

final class AccountViewModel: ViewModelType {
    
    public let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension AccountViewModel {
    
    struct Input {
    }
    

    struct Output {
        
    }
}
