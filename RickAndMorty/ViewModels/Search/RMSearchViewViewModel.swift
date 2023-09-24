//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 15.09.2023.
//

import Foundation

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    private var searchResultsHandler: ((RMSearchResultViewModel) -> Void)?
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultsHandler = block
    }
    
    public func executeSearch() {
        print("Search text: \(searchText)")
        
        // Build arguments
        var queryParams: [URLQueryItem] = [
            
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        
    

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
            }))
        
        // Create request
        var request = RMRequest(endpoint: config.type.endpoint,
                                queryParameter: queryParams
        )
        print(request.url?.absoluteString)
        
//        switch config.type.endpoint {
//            case .character:
//
//            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
//                switch result {
//                case .success(let model):
//                    // Episode, character
//                    print("Search results found \(model.results.count)")
//                case .failure:
//                    break
//                }
//            }
//
//            case .episode:
//
//            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { result in
//                switch result {
//                case .success(let model):
//                    // Episode, character
//                    print("Search results found \(model.results.count)")
//                case .failure:
//                    break
//                }
//            }
//
//            case .location:
//
//            RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { result in
//                switch result {
//                case .success(let model):
//                    // Episode, character
//                    print("Search results found \(model.results.count)")
//                case .failure:
//                    break
//                }
//            }
//
//            }
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
 
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                // Episode, character
                self?.processSearchResults(model)
                if let a = model as? RMGetAllEpisodesResponse {
                    print("Search results found \(a.results.count)")
                }
                
            case .failure:
                break
            }
        }
    }
    
    private func processSearchResults(_ model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string:$0.image))
            }))
           
        } else if let episodeResults = model as? RMGetAllEpisodesResponse {
            
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))

          
        }  else if let locationResults = model as? RMGetAllLocationsResponse {
            
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
          
        }
        if let results = resultsVM {
            self.searchResultsHandler?(results)
        }
        else {
            // Error; No results view
        }
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)) {
        self.optionMapUpdateBlock = block
    }
} 
