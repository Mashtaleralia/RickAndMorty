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
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

