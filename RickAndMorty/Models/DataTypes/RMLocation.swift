//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import Foundation

struct RMLocation: Codable, RMOriginRender {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
