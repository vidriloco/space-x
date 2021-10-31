//
//  MainViewCoordinator.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import UIKit

class MainViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let serviceRepository = ClientRepository()

    private let filterViewCoordinator: FilterViewCoordinator?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        
        self.filterViewCoordinator = FilterViewCoordinator(presenter: presenter)
    }
    
    func start() {
        let mainViewController = MainViewController(with: .init(title: "Space X", filterText: "Filter", service: serviceRepository))
        mainViewController.delegate = self
        presenter.pushViewController(mainViewController, animated: true)
    }
    
}

extension MainViewCoordinator: MainViewControllerDelegate {
    func willShowFilterOptions(from controller: UIViewController) {
        filterViewCoordinator?.start()
    }
}
