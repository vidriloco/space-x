//
//  CompanyViewModel.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import Foundation

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func willReloadTable()
    func willDisplayError()
    func displayLoadingIndicator()
    func hideLoadingIndicator()
}

// MARK: - MainViewModel

final class MainViewModel {
    let title: String
    let filterText: String
    
    private var companyInfo: CompanyInfo?
    
    private var launches: [LaunchViewModel]?
        
    private var service: ClientRepositable?
    
    weak var delegate: MainViewModelDelegate?
    
    private var dispatchGroup = DispatchGroup()
    
    private var errors = [ClientRepository.APIError]()
    
    var sections: [Section] {
        if let bio = companyBio, let launches = launches, errors.isEmpty {
            if launches.isEmpty {
                return [.companyBioSection(bio), .emptyLaunchesSection]
            }
            return [.companyBioSection(bio), .launchesSection(launches)]
        }
        
        return []
    }
    
    init(title: String, filterText: String, service: ClientRepositable) {
        self.title = title
        self.filterText = filterText
        self.service = service
    }
    
    func viewDidLoad() {
        delegate?.displayLoadingIndicator()
        updateCompanyInfo()
        updateLaunchesList()
        loadObserver()
        setNotifyActionForDispatchGroup()
    }
    
    func viewNeedsUpdate() {
        errors.removeAll()
        delegate?.displayLoadingIndicator()
        updateCompanyInfo()
        updateLaunchesList()
        setNotifyActionForDispatchGroup()
    }
    
    func updateCompanyInfo() {
        dispatchGroup.enter()
        
        service?.getCompanyInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let companyInfo):
                self.companyInfo = companyInfo.toCompanyInfo()
            case .failure(let error):
                self.errors.append(error)
            }
            
            self.dispatchGroup.leave()
        }
    }
    
    func updateLaunchesList(ordering: String? = nil, launchStatus: String? = nil, year: String? = nil) {
        dispatchGroup.enter()
        
        service?.getLaunches(ordering: ordering, launchStatus: launchStatus, year: year, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let launches):
                self.launches = launches.map { LaunchViewModel(with: $0.toLaunch()) }
            case .failure(let error):
                self.errors.append(error)
            }
            
            self.dispatchGroup.leave()
        })
    }
    
    func setNotifyActionForDispatchGroup() {
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if self.errors.isEmpty {
                self.willUpdateTableView()
            } else {
                self.willDisplayError()
            }
            
            self.delegate?.hideLoadingIndicator()
        }
    }
}

// MARK: - MainViewModel (private extensions)

private extension MainViewModel {
    var companyBio: String? {
        guard let companyInfo = companyInfo else { return nil }
        return "\(companyInfo.companyName) was founded by \(companyInfo.founderName) in \(companyInfo.year). It has now \(companyInfo.employees) employees, \(companyInfo.launchSites) launch sites and is valued at USD \(companyInfo.valuation)"
    }
    
    func willUpdateTableView() {
        DispatchQueue.main.async {
            self.delegate?.willReloadTable()
        }
    }
    
    func willDisplayError() {
        DispatchQueue.main.async {
            self.delegate?.willDisplayError()
        }
    }
    
    func loadObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSelectionParamsChanged(_:)),
            name: NotificationMessages.selectionParams,
            object: nil)
    }
}

// MARK: - MainViewModel (Section type definition)

extension MainViewModel {
    
    enum Section {
        case companyBioSection(String)
        case launchesSection([LaunchViewModel])
        case emptyLaunchesSection
    }
    
}

// MARK: - MainViewModel (@objc extensions)

@objc extension MainViewModel {
    func didSelectionParamsChanged(_ notification: NSNotification) {
        errors.removeAll()
        dispatchGroup = DispatchGroup()
        updateLaunchesList(ordering: notification.userInfo?["ordering"] as? String,
                           launchStatus: notification.userInfo?["launch-status"] as? String,
                           year: notification.userInfo?["year"] as? String)
        setNotifyActionForDispatchGroup()
        delegate?.displayLoadingIndicator()
    }
}
