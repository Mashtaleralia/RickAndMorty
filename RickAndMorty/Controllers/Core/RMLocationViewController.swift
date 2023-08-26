//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Admin on 05.08.2023.
//

import UIKit

/// Controller to show and search for Lication
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       title = "Locations"
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }

}
