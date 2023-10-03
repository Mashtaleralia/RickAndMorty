//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Admin on 02.10.2023.
//

import UIKit

class RMTableLoadingFooterView: UIView {
     
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(spinner)
        addConstraints()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

}
