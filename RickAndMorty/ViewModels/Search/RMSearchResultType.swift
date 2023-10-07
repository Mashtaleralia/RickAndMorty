//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 21.09.2023.
//

import Foundation

final class RMSearchResultsViewModel {
    public private(set) var results: RMSearchResultType
    var next: String?
    public private(set) var isLoadingMoreResults = false
   
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next, let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                print("More locations: \(moreResults.count)")
                strongSelf.next = info.next
                
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .characters, .episodes:
                    break
                }
             
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    completion(newResults)
//                    strongSelf.didFinishPagination?()
                }
               
               
                //strongSelf.apiInfo = info
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreResults = false
            }
        }
    }
    
    func fetchAdditionalResults(completion: @escaping ([AnyHashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next, let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    print("More locations: \(moreResults.count)")
                    strongSelf.next = info.next
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.url))
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        completion(newResults)
                    }
                    
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreResults = false
                }
            }
        
        case .episodes(let existingResults):
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    print("More locations: \(moreResults.count)")
                    strongSelf.next = info.next
                    
                    let additionalLocations = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [RMLocationTableViewCellViewModel] = []
                  
                 
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreResults = false
                }
            }
        
        case .locations:
            break
        }
    }
}


enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
