//
//  LoginModel.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

struct LoginRequestModel: Codable {
    
    var email, password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}

struct LoginResponseModel: Codable {
    
    var user: UserModel?
    
}

struct UserModel: Codable {
    
    var userId: Int
    var userName, createdAt: String
    var userProfileUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileUrl = "user_profile_url"
        case createdAt = "created_at"
    }
    
}

class ResponseModel<T: Codable>: BaseResponseModel, Codable {
    
    var result: Int
    var errorMessage: String
    var data: T
    
    enum CodingKeys: String, CodingKey {
        case result, data
        case errorMessage = "error_message"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(Int.self, forKey: .result)
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
        data = try container.decode(T.self, forKey: .data)
    }
}

protocol BaseResponseModel {
    
    var result: Int { get set }
    var errorMessage: String { get set }
}
