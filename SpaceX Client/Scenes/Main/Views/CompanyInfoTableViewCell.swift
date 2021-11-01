//
//  CompanyInfoViewCell.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import Foundation
import UIKit

class CompanyInfoTableViewCell: UITableViewCell {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    func configure(with description: String) {
        descriptionLabel.text = description
        configureViews()
    }
}

private extension CompanyInfoTableViewCell {

    func configureViews() {
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalMargin),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalMargin),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.verticalMargin)
        ])
    }

    struct Constants {
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 10
    }
}
