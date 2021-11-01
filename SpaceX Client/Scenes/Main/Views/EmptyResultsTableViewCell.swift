//
//  EmptyResultsTableViewCell.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 01/11/2021.
//

import UIKit

// MARK: - EmptyResultsTableViewCell

class EmptyResultsTableViewCell: UITableViewCell {
    
    private let edgeCaseView: EdgeCaseListView = {
        let view = EdgeCaseListView(with: "Nothing here to see",
                                    message: "There are no items to display under the current filter selection")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func configure() {
        contentView.addSubview(edgeCaseView)

        NSLayoutConstraint.activate([
            edgeCaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            edgeCaseView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: edgeCaseView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: edgeCaseView.bottomAnchor),
        ])
    }
}

// MARK: - EmptyResultsTableViewCell (Constants and private methods)

private extension EmptyResultsTableViewCell {
    
    struct Constants {
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 20
        static let missionPatchIconDimensions: CGFloat = 30
        static let iconDimensions: CGFloat = 25
    }
    
}
