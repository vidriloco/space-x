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
}

final class MainViewModel {
    let title: String
    let filterText: String
    
    private var companyInfo: CompanyInfo?
    
    private var launches: [LaunchViewModel]?
        
    private var service: ClientRepositable?
    
    weak var delegate: MainViewModelDelegate?
    
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
        updateCompanyInfo()
        updateLaunchesList()
    }
    
    func updateCompanyInfo() {
        service?.getCompanyInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let companyInfo):
                self.companyInfo = companyInfo.toCompanyInfo()
                self.willUpdateTableView()
            case .failure(let error):
                self.willDisplay(error: error)
            }
        }
    }
    
    func updateLaunchesList() {
        service?.getLaunches(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let launches):
                self.launches = launches.map { LaunchViewModel(with: $0.toLaunch()) }
                self.willUpdateTableView()
            case .failure(let error):
                self.willDisplay(error: error)
            }
        })
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
    
}
