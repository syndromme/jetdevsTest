//
//  ViewModelType.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
