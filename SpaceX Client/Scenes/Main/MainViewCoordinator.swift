//
//  MainViewCoordinator.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 31/10/2021.
//

import UIKit

// MARK: - MainViewCoordinator

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

// MARK: - MainViewCoordinator (MainViewControllerDelegate adherence)

extension MainViewCoordinator: MainViewControllerDelegate {
    func willShowFilterOptions(from controller: UIViewController) {
        filterViewCoordinator?.start()
    }
    
    func willShowLinkChooserAlert(wikipediaURL: String?, youtubeURL: String?, youtubeIdURL: String?, articleURL: String?) {
        let alert = UIAlertController(title: "Choose an action to proceed", message: "You can access more information of this Launch event. Select a resource option from below to open:", preferredStyle: .alert)

        if let articleURL = articleURL {
            alert.addAction(UIAlertAction(title: "Article", style: .default, handler: { [weak self] _ in
                self?.openURL(articleURL)
            }))
        }
        
        if let wikipediaURL = wikipediaURL {
            alert.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { [weak self] _ in
                self?.openURL(wikipediaURL)
            }))
        }
        
        if youtubeURL != nil || youtubeIdURL != nil {
            alert.addAction(UIAlertAction(title: "Youtube", style: .default, handler: { [weak self] _ in
                guard let unpackedYouTubeIdURL = youtubeIdURL,
                        let localURL = URL(string: unpackedYouTubeIdURL) else { return }
                
                if UIApplication.shared.canOpenURL(localURL) {
                    UIApplication.shared.open(localURL, options: [:], completionHandler: nil)
                } else {
                    guard let youtubeURL = youtubeURL else { return }
                    self?.openURL(youtubeURL)
                }
                
            }))
        }

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))

        presenter.present(alert, animated: true)
    }
    
    func openURL(_ webURL: String) {
        guard let url = URL(string: webURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - NotificationMessages

struct NotificationMessages {
    static let selectionParams = Notification.Name("didReceiveSelectionParams")
}
