//
//  SectionHeaderCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Admin on 22.08.2023.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "SectionHeaderCollectionReusableView"
    
    public var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
          super.init(frame: frame)

          addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}
