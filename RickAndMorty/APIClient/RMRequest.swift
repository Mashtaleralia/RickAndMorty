//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import Foundation


/// Object that represents a single API call
final class RMRequest {
    /// API constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    let endpoint: RMEndpoint
    
    /// Path componets for API, If any
    let pathComponents: [String]
    
    /// Query arguments for API, if any
    let queryParameter: [URLQueryItem]
    
    /// Constructed url for API request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        if !queryParameter.isEmpty {
            string += "?"
            let argumentString = queryParameter.compactMap({
                guard let value = $0.value else {
                    return nil
                }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameter: Collection of query parameters
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameter: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameter = queryParameter
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameter: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharacterRequest = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
    static let listLocationRequest = RMRequest(endpoint: .location)
}
