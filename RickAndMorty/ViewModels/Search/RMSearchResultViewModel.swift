//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 21.09.2023.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
