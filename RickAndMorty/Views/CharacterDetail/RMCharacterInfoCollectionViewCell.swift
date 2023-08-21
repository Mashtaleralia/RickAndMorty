//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Admin on 18.08.2023.
//
import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    
    private func makeLabels() {
        let labelNames = ["Species:", "Type:", "Gender:"]
        var prev = contentView.topAnchor
        for i in 0 ..< labelNames.count {
            let label = UILabel()
            label.text = labelNames[i]
            label.textColor = UIColor(red: 0.77, green: 0.79, blue: 0.81, alpha: 1)
            label.font = .systemFont(ofSize: 16)
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            label.topAnchor.constraint(equalTo: prev, constant: 16).isActive = true
            prev = label.bottomAnchor
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.15, green: 0.16, blue: 0.22, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.addSubviews(genderLabel, typeLabel, speciesLabel)
        setUpConstraints()
        makeLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            speciesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            speciesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            typeLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            genderLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 16),
            genderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genderLabel.text = nil
        speciesLabel.text = nil
        typeLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        speciesLabel.text = viewModel.species
        genderLabel.text = viewModel.gender
        if viewModel.type.isEmpty {
            typeLabel.text = "None"
        } else {
            typeLabel.text = viewModel.type
        }
       
    }
}
