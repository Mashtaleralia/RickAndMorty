//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 24.08.2023.
//

import UIKit

protocol  RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode:  RMEpisode)
}

final class  RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate:  RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreChatacters = false
    
    private var episodes: [ RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel =  RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    /// Fetch initial set of episodes (20)
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodesRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
            
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalEpisodes (url: URL) {
        guard !isLoadingMoreChatacters else {
            return
        }
        print("Fetching more data")
        isLoadingMoreChatacters = true
        print("Fetching more characters")
        guard let request = RMRequest(url: url) else {
            isLoadingMoreChatacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
    
                strongSelf.episodes .append(contentsOf: moreResults)
                print("Post-update: \(strongSelf.cellViewModels.count)")
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    strongSelf.isLoadingMoreChatacters = false

                }
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreChatacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        
        return apiInfo?.next != nil
    }
}

extension  RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as?  RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator else {
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)
        return CGSize(width: width, height: width*0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

extension  RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !cellViewModels.isEmpty, !isLoadingMoreChatacters, let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes (url: url)
            }
            t.invalidate()
        }
       
        
    }
}
