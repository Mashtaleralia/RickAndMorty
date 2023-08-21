//
//  RMCharacterOriginCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 21.08.2023.
//

import UIKit

protocol RMOriginRender {
    var name: String { get }
    var type: String { get }
}

final class RMCharacterOriginCollectionViewCellViewModel {
    public let originUrl: URL?
    
    private var isFetching = false
    
    public var originLocation: RMLocation? {
        didSet {
            guard let model = originLocation else {
                return
            }
            dataBlock?(model)
        }
    }
    
    init(url: URL?) {
        self.originUrl = url
    }
    
    private var dataBlock: ((RMOriginRender) -> Void)?
    
    public func registerForData(_ block: @escaping ((RMOriginRender) -> Void)) {
        self.dataBlock = block
    }
    
    public func fetchOrigin() {
        guard !isFetching else {
            if let model = originLocation {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = originUrl, let request = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMLocation.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.originLocation = model
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
}

