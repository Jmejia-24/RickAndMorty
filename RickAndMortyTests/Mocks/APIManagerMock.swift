//
//  APIManagerMock.swift
//  RickAndMortyTests
//
//  Created by Byron Mejia on 3/15/23.
//

import Foundation
import Combine

@testable import RickAndMorty

final class APIManagerMock: APIManagerStore {
    func execute<T>(_ request: RickAndMorty.Request) -> Future<T, Error> where T : Decodable, T : Encodable {
        return Future { promise in
            guard let urlPath = Bundle(for: APIManagerMock.self).url(forResource: request.endpoint.rawValue, withExtension: "json"),
                  let jsonString = (try? String(contentsOf: urlPath, encoding: .utf8)),
                  let data = jsonString.data(using: .utf8),
                  let result = (try? JSONDecoder().decode(T.self, from: data))
            else {
                promise(.failure(Failure.failedToGetData))
                return }
            promise(.success(result))
        }
    }
    
    static let shared = APIManagerMock()
    
    private init() {}
}
