//
//  RMService.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {}
    
    /// Send Rick and Morty api call
    /// - Parameters:
    ///   - execute: Request instance
    ///   - completion: Callback with data or error
    public func execute(_ execute: RMRequest, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
}
