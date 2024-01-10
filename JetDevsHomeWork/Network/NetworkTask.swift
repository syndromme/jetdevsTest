//
//  NetworkTask.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation
import Alamofire

class NetworkTask {
    
    class func createParams(_ service: NetworkService) -> Parameters {
        switch service {
        case .login(let parameter):
            return parameter.dictionary
        }
    }
}
