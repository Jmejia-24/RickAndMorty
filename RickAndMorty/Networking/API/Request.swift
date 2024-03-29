//
//  Request.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import Foundation

final class Request {
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    let endpoint: Endpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]

    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }

        return string
    }

    var url: URL? {
        return URL(string: urlString)
    }

    let httpMethod = "GET"

    // MARK: - Public

    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of query parameters
    public init(endpoint: Endpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: "\(Constants.baseUrl)/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }

                if let rmEndpoint = Endpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]

                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else { return nil }

                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                }

                if let rmEndpoint = Endpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

extension Request {
    static let listCharactersRequests = Request(endpoint: .character)
    static let listEpisodesRequest = Request(endpoint: .episode)
    static let listLocationsRequest = Request(endpoint: .location)
}
