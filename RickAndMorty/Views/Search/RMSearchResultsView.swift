//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Admin on 24.09.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResult(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
    func rmSearchResult(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int)
    func rmSearchResult(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int)
}

/// Shows searchr esults UI (table or collection)
final class RMSearchResultsView: UIView {
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    private var viewModel: RMSearchResultsViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    /// CollectionView ViewModels
    private var collectionViewCellViewModels = [AnyHashable]()
    
    /// TableView viewModels
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.backgroundColor = UIColor(red: 0.02, green: 0.05, blue: 0.12, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        addSubviews(tableView, collectionView)
        addConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel.results {
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
           setUpCollectionView()
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        }
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        collectionView.isHidden = true
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    private func setUpCollectionView() {
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func addConstarints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }
    
    public func configure(with viewModel: RMSearchResultsViewModel) {
        self.viewModel = viewModel
    }
    
}
// MARK: - TableView

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResult(self, didTapLocationAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    private func showTableLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        tableView.tableFooterView = footer
    }
    
}

extension RMSearchResultsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.locationCellViewModels.isEmpty {
            handlePagination(scrollView: scrollView)
        } else {
            handleEpisodeOrCharacterPagination(scrollView: scrollView)
        }
       
    }
    
    private func handleEpisodeOrCharacterPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
                //!locationCellViewModels.isEmpty,
                viewModel.shouldShowLoadMoreIndicator,
        !viewModel.isLoadingMoreResults else {
            print(locationCellViewModels.count)
            return
        }
        let offset = scrollView.contentOffset.y
        let totalFixedHeight = scrollView.frame.size.height
        let totalContentHeight = scrollView.contentSize.height
    
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] t in
                if offset >= (totalContentHeight - totalFixedHeight - 120) {
                    
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.showTableLoadingIndicator()
                    }
                    
                    let originalResults = strongSelf.collectionViewCellViewModels

                    viewModel.fetchAdditionalResults { [weak self] newResults in
                        // Refresh table
//                        let moreResults = responseModel.results
                        DispatchQueue.main.async {
                            let originalCount = strongSelf.collectionViewCellViewModels.count
                            let newCount = newResults.count - originalCount
                            let total = originalCount + newCount
                            let startingIndex = total - newCount
                            let indexPathToAdd: [IndexPath] = Array((startingIndex..<startingIndex+newCount).compactMap({
                                return IndexPath(row: $0, section: 0)
                            }))
                            
                            strongSelf.collectionViewCellViewModels = newResults
                            strongSelf.collectionView.insertItems(at: indexPathToAdd)
                        }
                    }
                }
                t.invalidate()
            }
    }
     
    private func handlePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel, !locationCellViewModels.isEmpty, viewModel.shouldShowLoadMoreIndicator,
        !viewModel.isLoadingMoreResults else {
            return
        }
        let offset = scrollView.contentOffset.y
        let totalFixedHeight = scrollView.frame.size.height
        let totalContentHeight = scrollView.contentSize.height
    
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] t in
                if offset >= (totalContentHeight - totalFixedHeight - 120) {
                    DispatchQueue.main.async {
                        self?.showTableLoadingIndicator()
                    }

                    viewModel.fetchAdditionalLocations { [weak self] newResults in
                        // Refresh table
                        self?.tableView.tableFooterView = nil
                        self?.locationCellViewModels = newResults
                        self?.tableView.reloadData()
                    }
                }
                t.invalidate()
            }
    }
     
}


//MARK: - CollectionView

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
          
            cell.configure(with: characterVM)
        
            
            return cell
        }
        //Episode
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel.results {
        case .episodes:
            delegate?.rmSearchResult(self, didTapEpisodeAt: indexPath.row)
        case .characters:
            delegate?.rmSearchResult(self, didTapCharacterAt: indexPath.row)
        case .locations:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            // Character size
            let bounds = UIScreen.main.bounds
            let width = UIDevice.isIphone ? (bounds.width - 30)/2 : (bounds.width - 30)/4
            return CGSize(width: width, height: width * 1.25)
        }
        
        //Episode size
        
        let bounds = UIScreen.main.bounds
        let width = bounds.width - 20
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator else {
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}
