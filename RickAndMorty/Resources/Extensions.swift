//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Admin on 07.08.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
