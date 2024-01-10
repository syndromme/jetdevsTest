//
//  NetworkService.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

public protocol TargetType {
    
    var method: Alamofire.HTTPMethod { get }
    var url: RxAlamofire.URL { get }
    var parameters: Alamofire.Parameters { get }
}

enum NetworkService {
    case login(parameter: LoginRequestModel)
}

extension NetworkService: TargetType {
    
    private var baseUrl: URL {
        return URL(string: isDebug ? debugBaseURL : prodBaseURL)!
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    public var url: URL {
        return baseUrl.appendingPathComponent(NetworkPath.createPath(self))
    }
    
    public var parameters: Parameters {
        return NetworkTask.createParams(self)
    }
    
    public var rawBody: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .login:
            if let theJSONData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                request.httpBody = theJSONData
            }
        }
        return request
    }
}

final class Network<T: Decodable> {
    private let networkService: NetworkService
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
    }
    
    func getData() -> Observable<T> {
        return RxAlamofire
            .request(networkService.method, networkService.url, parameters: networkService.parameters)
            .debug()
            .observeOn(scheduler)
            .data()
            .map ({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
    
    func getDataWithRawBody() -> Observable<T> {
        return RxAlamofire
            .request(networkService.rawBody)
            .debug()
            .observeOn(scheduler)
            .data()
            .map ({ data -> T in
                let result = String(data: data, encoding: .utf8)
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
    
}
