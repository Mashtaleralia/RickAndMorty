//
//  RMEpisodeInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 26.08.2023.
//

import Foundation

final class RMEpisodeInfoCollectionViewCellViewModel {
    public let title: String
    public let value: String
    
    init(title: String, value: String) {
        self.value = value
        self.title = title
    }
}
