//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

final class AccountViewModel {
    
    public let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
}

extension AccountViewModel {
    
    struct Input {
        
    }

}
