//
//  Validation+Extension.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 18/01/24.
//

import Foundation

enum ValidationResult {
    case valid
    case empty
    case failed(message: String)
}

extension ValidationResult: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .empty, .valid:
            return ""
        case let .failed(message):
            return message
        }
    }
}

func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.valid, .valid):
        return true
    case (.empty, .empty):
        return true
    case (.failed, .failed):
        return true
    default:
        return false
    }
}
