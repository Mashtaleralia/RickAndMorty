//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import UIKit

/// Controller to show and search for Lication
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {

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
        primaryView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - RMLocationViewDelegate
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
