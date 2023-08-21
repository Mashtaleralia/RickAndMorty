//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 18.08.2023.
//

import UIKit

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    public let name: String
    
    public let status: String
    
    init(imageUrl: URL?, name: String, status: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.status = status
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(imageUrl, completion: completion)
    }
}
