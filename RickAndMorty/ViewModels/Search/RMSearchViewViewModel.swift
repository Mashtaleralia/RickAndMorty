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
    private var searchResultsHandler: ((RMSearchResultsViewModel) -> Void)?
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultModel: Codable?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultsViewModel) -> Void) {
        self.searchResultsHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        print("Search text: \(searchText)")
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
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
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(_ model: Codable) {
        var resultsVM: RMSearchResultType?
        var nextUrl: String?
       
        
        if let characterResults = model as? RMGetAllCharactersResponse {
            
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string:$0.image))
            }))
            nextUrl = characterResults.info.next
           
        } else if let episodeResults = model as? RMGetAllEpisodesResponse {
            
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = episodeResults.info.next
          
        }  else if let locationResults = model as? RMGetAllLocationsResponse {
            
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationResults.info.next
        }
        if let results = resultsVM {
            self.searchResultModel = model
            let vm = RMSearchResultsViewModel(results: results, next: nextUrl)
            self.searchResultsHandler?(vm)
        }
        else {
            // Error; No results view
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        //print("no result")
        noResultsHandler?()
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
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModel = searchResultModel as? RMGetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func characterSearchResult(at index: Int) -> RMCharacter? {
        guard let searchModel = searchResultModel as? RMGetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    
} 
