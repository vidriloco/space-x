//
//  CompanyViewModel.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func shouldReloadTable()
    func shouldDisplayError()
    func displayLoadingIndicator()
    func hideLoadingIndicator()
}

final class MainViewModel {
    let title: String
    let filterText: String
    
    private var companyInfo: CompanyInfo?
    
    private var launches: [LaunchViewModel]?
        
    private var service: ClientRepositable?
    
    weak var delegate: MainViewModelDelegate?
    
    private var group = DispatchGroup()
    
    var entries: [Section] {
        return [.companyBioSection(companyBio),
                .launchesSection(launches ?? [])]
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
        configureDispatchGroup()
    }
    
    func updateCompanyInfo() {
        group.enter()
        
        service?.getCompanyInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let companyInfo):
                self.companyInfo = companyInfo.toCompanyInfo()
            case .failure(let error):
                self.willDisplay(error: error)
            }
            
            self.group.leave()
        }
    }
    
    func updateLaunchesList(ordering: String? = nil, launchStatus: String? = nil, year: String? = nil, isRefresh: Bool = false) {
        group.enter()
        
        service?.getLaunches(ordering: ordering, launchStatus: launchStatus, year: year, completion: { [weak self] result in
            guard let self = self else { return }
            
            if isRefresh { self.delegate?.hideLoadingIndicator() }

            switch result {
            case .success(let launches):
                self.launches = launches.map { LaunchViewModel(with: $0.toLaunch()) }
                if isRefresh { self.willUpdateTableView() }
            case .failure(let error):
                self.willDisplay(error: error)
            }
            
            self.group.leave()
        })
    }
    
    func configureDispatchGroup() {
        group.notify(queue: .main) { [weak self] in
            self?.willUpdateTableView()
            self?.delegate?.hideLoadingIndicator()
        }
    }
}

private extension MainViewModel {
    var companyBio: String {
        guard let companyInfo = companyInfo else { return "" }
        return "\(companyInfo.companyName) was founded by \(companyInfo.founderName) in \(companyInfo.year). It has now \(companyInfo.employees) employees, \(companyInfo.launchSites) launch sites and is valued at USD \(companyInfo.valuation)"
    }
    
    func willUpdateTableView() {
        DispatchQueue.main.async {
            self.delegate?.shouldReloadTable()
        }
    }
    
    func willDisplay(error: ClientRepository.APIError) {
        DispatchQueue.main.async {
            self.delegate?.shouldDisplayError()
        }
    }
}

extension MainViewModel {
    
    enum Section {
        case companyBioSection(String)
        case launchesSection([LaunchViewModel])
    }
    
    func loadObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSelectionParamsChanged(_:)),
            name: NotificationMessages.selectionParams,
            object: nil)
    }
    
    @objc func didSelectionParamsChanged(_ notification: NSNotification) {
        group = DispatchGroup()
        updateLaunchesList(ordering: notification.userInfo?["ordering"] as? String,
                           launchStatus: notification.userInfo?["launch-status"] as? String,
                           year: notification.userInfo?["year"] as? String,
                           isRefresh: true)
        delegate?.displayLoadingIndicator()
    }
}
