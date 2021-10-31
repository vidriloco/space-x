//
//  FilterViewCoordinator.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func dismiss(from controller: UIViewController)
    func save(from controller: UIViewController)
}


class FilterViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    
    private let selectionParams = FilterViewModel.SelectionParams()
    private let filterViewModel: FilterViewModel = .init(yearSelectorOptions: Array(2000...2017))
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let filterViewController = buildFilterViewController()
        
        presenter.present(filterViewController, animated: true)
    }
    
}

private extension FilterViewCoordinator {
    func buildFilterViewController() -> UIViewController {
        let filterViewController = FilterViewController(with: filterViewModel)
        filterViewController.delegate = self
        let navigationViewController = UINavigationController(rootViewController: filterViewController)
        navigationViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        
        if let sheet = navigationViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        return navigationViewController
    }
}

extension FilterViewCoordinator: FilterViewControllerDelegate {
    func dismiss(from controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func save(from controller: UIViewController) {
        dismiss(from: controller)
    }
    
    
}
