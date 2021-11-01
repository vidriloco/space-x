//
//  EmptyListView.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 01/11/2021.
//

import UIKit

protocol EdgeCaseListViewDelegate: AnyObject {
    func didTapActionButton()
}

class EdgeCaseListView: UIView {

    weak var delegate: EdgeCaseListViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.tinted(), primaryAction: .init(handler: { [weak self] _ in
            self?.delegate?.didTapActionButton()
        }))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10

        return stackView
    }()

    public init(with title: String, message: String, iconName: String? = "empty-icon", buttonText: String? = nil) {
        super.init(frame: .zero)

        titleLabel.text = title
        messageLabel.text = message
        actionButton.setTitle(buttonText, for: .normal)
        actionButton.isHidden = buttonText == nil

        if let iconName = iconName { imageView.image = UIImage(named: iconName) }

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureView() {
        stackView.addArrangedSubview(imageView)
        stackView.setCustomSpacing(Constants.spacingBetweenIconAndText, after: imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.iconDimensions),
            imageView.widthAnchor.constraint(equalToConstant: Constants.iconDimensions),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalMargin)
        ])
    }

}

extension EdgeCaseListView {
    struct Constants {
        static let iconDimensions: CGFloat = 80
        static let spacingBetweenIconAndText: CGFloat = 30
        static let horizontalMargin: CGFloat = 20
    }
}
