//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import UIKit
import Combine

final class APIManager {
    static let shared = APIManager()
    
    private let cacheManager = APICacheManager()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: Request) -> Future<T, Error> where T : Codable {
        return Future { [unowned self] promise in
            
            if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
                do {
                    let result = try JSONDecoder().decode(T.self, from: cachedData)
                    promise(.success(result))
                }
                catch {
                    promise(.failure(error))
                }
                return
            }
            
            guard let urlRequest = self.request(from: request) else {
                promise(.failure(Failure.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil else {
                    promise(.failure(error ?? Failure.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    self.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                    promise(.success(result))
                }
                catch {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private
    
    private func request(from request: Request) -> URLRequest? {
        guard let url = request.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
