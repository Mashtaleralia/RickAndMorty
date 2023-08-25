//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Admin on 21.08.2023.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {
    
    private let viewModel: RMEpisodeDetailViewViewModel
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = UIColor(red: 0.02, green: 0.05, blue: 0.12, alpha: 1)
    }
 

}
