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
    
    private let mainViewCoordinator: MainViewCoordinator?

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
        self.mainViewCoordinator = MainViewCoordinator(presenter: rootViewController)
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        mainViewCoordinator?.start()
    }
}
