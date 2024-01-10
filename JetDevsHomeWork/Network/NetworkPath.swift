//
//  Networks.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

final class NetworkPath {
    
    class func createPath(_ service: NetworkService) -> String {
        switch service {
        case .login:
            return "login"
        }
    }
}
