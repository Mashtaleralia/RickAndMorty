//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Admin on 24.09.2023.
//

import UIKit

/// Shows searchr esults UI (table or collection)
final class RMSearchResultsView: UIView {
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        addSubviews(tableView)
        addConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel {
        case .locations(let viewModels):
            setUpCollectionView()
        case .episodes(let viewModels):
            setUpTableView()
        case .characters(let viewModels):
            setUpCollectionView()
        }

    }
    
    private func setUpTableView() {}
    
    private func setUpCollectionView() {
        tableView.isHidden = true
    }
    
    private func addConstarints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        tableView.backgroundColor = .green
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        
    }
    
}
