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

public protocol NetworkService {
    
    var method: Alamofire.HTTPMethod { get }
    var parameters: Alamofire.Parameters? { get }
    var path: String { get }
}

class NetworkManager {
    
    public static let shared = NetworkManager()
    
    var baseURL: String = ""
    var service: NetworkService?
    
    private init() {}
    
    var request: URLRequest {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        
        guard let service = service else {
            return request
        }
        
        let path = url.appendingPathComponent(service.path)
        request.url = path
        request.httpMethod = service.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = service.parameters {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                request.httpBody = theJSONData
            }
        }
        return request
    }
}

final class Network<T: Decodable> {
    private let networkService: NetworkManager = NetworkManager.shared
    private let scheduler: ConcurrentDispatchQueueScheduler
    
//    let reachability = Reachability()!
    
    init() {
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
    }
    
    func load() -> Observable<T> {
        return RxAlamofire
            .request(networkService.request)
            .debug()
            .observeOn(scheduler)
            .data()
            .map({ data -> T in
//                let result = String(data: data, encoding: .utf8)
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
}
