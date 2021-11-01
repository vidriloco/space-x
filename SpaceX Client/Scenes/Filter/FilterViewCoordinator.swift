//
//  FilterViewCoordinator.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func dismissFilter(from controller: UIViewController)
    func saveFilterSelection(from controller: UIViewController)
}

class FilterViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    
    private var selectionParams = FilterViewModel.SelectionParams()
    private let filterViewModel: FilterViewModel = .init(yearSelectorOptions: Array(2006...2021))
    
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
        filterViewModel.selectedParams = selectionParams
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
    func saveFilterSelection(from controller: UIViewController) {
        dismissFilter(from: controller)
        
        var userInfo = [String: String]()
        
        if let year = selectionParams.year {
            userInfo["year"] = "\(year)"
        }
        
        userInfo["ordering"] = selectionParams.orderingOption.apiString
        userInfo["launch-status"] = selectionParams.launchResultOption.apiString

        NotificationCenter.default.post(
            name: NotificationMessages.selectionParams,
            object: nil,
            userInfo: userInfo)
    }
    
    func dismissFilter(from controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
