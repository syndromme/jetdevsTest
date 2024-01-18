//
//  String+Extension.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 16/01/24.
//

import Foundation

extension String {
    
    func validatePattern(_ pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
