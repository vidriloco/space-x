//
//  AppCoordinator.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {

    private let window: UIWindow

    private let rootViewController: UINavigationController
    private let serviceRepository = ClientRepository()
    
    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        let mainViewController = MainViewController(with: .init(title: "Space X", service: serviceRepository))
        
        rootViewController.pushViewController(mainViewController, animated: true)
    }
}
