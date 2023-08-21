//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Admin on 18.08.2023.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.28, green: 0.77, blue: 0.04, alpha: 1)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.58, green: 0.6, blue: 0.61, alpha: 1)
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.15, green: 0.16, blue: 0.22, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.addSubviews(airDateLabel, seasonLabel, nameLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
//            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            seasonLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
        ])
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            print(data.name)
            print(data.air_date)
            print(data.episode)
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode " + data.episode
            self?.airDateLabel.text = data.air_date
        }
        viewModel.fetchEpisode()
    }
} 
