//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import UIKit

/// Controller to show and search for Lication
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate {

    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
       title = "Locations"
        view.addSubview(primaryView)
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }

}
