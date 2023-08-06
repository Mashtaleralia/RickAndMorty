//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import Foundation


/// Object that represents a single API call
final class RMRequest {
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    let endpoint: RMEndpoint
    
    let pathComponents: [String]
    
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
        }
        return string
    }
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameter: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameter = queryParameter
    }
}
