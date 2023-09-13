//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Admin on 11.09.2023.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    static let identifier = "RMLocationTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubviews(nameLabel, typeLabel, dimensionLabel)
        accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
           
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            typeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            dimensionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dimensionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
    
    public func configure(with viewModel: RMLocationTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        typeLabel.text = viewModel.type
        dimensionLabel.text = viewModel.dimension
    }
}
