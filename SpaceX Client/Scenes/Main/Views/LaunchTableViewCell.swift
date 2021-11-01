//
//  LaunchTableViewCell.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 30/10/2021.
//

import UIKit
import SDWebImage

class LaunchTableViewCell: UITableViewCell {

    private var missionIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    private var missionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()
    
    private var rocketLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()
    
    private var distanceInTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()
    
    private lazy var rowBasedContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missionLabel, dateLabel, rocketLabel, distanceInTimeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.spacingBetweenRows

        return stackView
    }()
    
    private lazy var columnBasedContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missionIconImageView, rowBasedContainerView, iconImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.setCustomSpacing(Constants.spacingBetweenColumns, after: missionIconImageView)
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    public func configure(with launchViewModel: LaunchViewModel) {
        missionLabel.attributedText = NSMutableAttributedString().bold(launchViewModel.missionLabelText).normal(launchViewModel.missionLabelValue)
        dateLabel.attributedText = NSMutableAttributedString().bold(launchViewModel.dateLabelText).normal(launchViewModel.dateLabelValue)
        rocketLabel.attributedText = NSMutableAttributedString().bold(launchViewModel.rocketLabelText).normal(launchViewModel.rocketLabelValue)
        distanceInTimeLabel.attributedText = NSMutableAttributedString().bold(launchViewModel.daysLabelText).normal(launchViewModel.daysLabelValue)
        
        if let imageURL = launchViewModel.missionPatchImageURL {
            missionIconImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        } else {
            missionIconImageView.image = UIImage(named: "no-image-icon")
        }
        
        iconImageView.image = launchViewModel.missionStatusImage
        configureConstraints()
    }
}

private extension LaunchTableViewCell {

    func configureConstraints() {
        contentView.addSubview(columnBasedContainerView)

        NSLayoutConstraint.activate([
            columnBasedContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            columnBasedContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            contentView.trailingAnchor.constraint(equalTo: columnBasedContainerView.trailingAnchor, constant: Constants.horizontalMargin),
            contentView.bottomAnchor.constraint(equalTo: columnBasedContainerView.bottomAnchor, constant: Constants.verticalMargin),
            missionIconImageView.widthAnchor.constraint(equalToConstant: Constants.missionPatchIconDimensions),
            missionIconImageView.heightAnchor.constraint(equalToConstant: Constants.missionPatchIconDimensions),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconDimensions),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconDimensions),
        ])
    }

    struct Constants {
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 20
        static let missionPatchIconDimensions: CGFloat = 30
        static let iconDimensions: CGFloat = 25
        static let spacingBetweenColumns: CGFloat = 15
        static let spacingBetweenRows: CGFloat = 2
    }
}
