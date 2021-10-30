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
    
    private var companyInfo: CompanyInfo?
    
    private var launches: [Launch]?
    
    private var error: ClientRepository.APIError?
    
    private var service: ClientRepositable?
    
    weak var delegate: MainViewModelDelegate?
    
    var entries: [Section] {
        return [.companyBioSection(companyBio),
                .launchesSection(launches ?? [])]
    }
    
    init(title: String, service: ClientRepositable) {
        self.title = title
        self.service = service
    }
    
    func viewDidLoad() {
        updateCompanyInfo()
    }
    
    func updateCompanyInfo() {
        service?.getCompanyInfo { [self] result in
            switch result {
            case .success(let companyInfo):
                self.companyInfo = companyInfo.toCompanyInfo()
                DispatchQueue.main.async {
                    self.delegate?.shouldReloadTable()
                }
            case .failure(let error):
                self.error = error
                DispatchQueue.main.async {
                    self.delegate?.shouldDisplayError()
                }
            }
        }
    }
}

private extension MainViewModel {
    private var companyBio: String {
        guard let companyInfo = companyInfo else { return "" }
        return "\(companyInfo.companyName) was founded by \(companyInfo.founderName) in \(companyInfo.year). It has now \(companyInfo.employees) employees, \(companyInfo.launchSites) launch sites and is valued at USD \(companyInfo.valuation)"
    }
}

extension MainViewModel {
    
    enum Section {
        case companyBioSection(String)
        case launchesSection([Launch])
    }
    
}
