//
//  RMCharacterOriginCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Admin on 21.08.2023.
//

import UIKit

class RMCharacterOriginCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterOriginCollectionViewCell"
    
    private let originLabel: UILabel = {
        let label = UILabel()
//        label.numberOfLines = 2
//        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let originTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.28, green: 0.77, blue: 0.04, alpha: 2)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "planet")
        
        return imageView
    }()
    
    private let planetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.1, green: 0.11, blue: 0.16, alpha: 1)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor =  UIColor(red: 0.15, green: 0.16, blue: 0.22, alpha: 1)
        contentView.layer.cornerRadius = 16

        contentView.addSubviews(originLabel, originTypeLabel, imageView, planetView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
           
            planetView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            planetView.heightAnchor.constraint(equalToConstant: 64),
            planetView.widthAnchor.constraint(equalToConstant: 64),
            planetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            
            imageView.centerXAnchor.constraint(equalTo: planetView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: planetView.centerYAnchor),
            
            originLabel.leadingAnchor.constraint(equalTo: planetView.trailingAnchor, constant: 16),
            originLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            originLabel.heightAnchor.constraint(equalToConstant: 22),
            originLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            originTypeLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 8),
            originTypeLabel.leadingAnchor.constraint(equalTo: planetView.trailingAnchor, constant: 16),
            originTypeLabel.heightAnchor.constraint(equalToConstant: 18)
            
            
        ])
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        originLabel.text = nil
        originTypeLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterOriginCollectionViewCellViewModel) {
        
            originLabel.text = "Unknown Origin"
            originTypeLabel.text = "Unknown Type"
        viewModel.registerForData { [weak self] data in
            self?.originLabel.text = data.name
            self?.originTypeLabel.text = data.type
            print("location:\(data.name)\(data.type)" )

            }
        viewModel.fetchOrigin()
        }
        
    }

