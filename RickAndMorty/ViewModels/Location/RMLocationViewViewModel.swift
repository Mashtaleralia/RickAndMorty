//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 11.09.2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
               
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    // Location response info
    // Will contain next url if present
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var didFinishPagination: (() -> Void)?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    // MARK: - Init
    
    init() {
        
    }
    
    public func didFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    // Notify via callback
                
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreLocations = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
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
                print(info.next)
                print("More locations: \(moreResults.count)")
                strongSelf.apiInfo = info
                 
               
                self?.didFinishPagination?()
                
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap {
                    return RMLocationTableViewCellViewModel(location: $0)
                    
                })
                strongSelf.isLoadingMoreLocations = false
               
                //strongSelf.apiInfo = info
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreLocations = false
            }
        }
        
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
