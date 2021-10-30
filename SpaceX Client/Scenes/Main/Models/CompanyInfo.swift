//
//  CompanyInfo.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import Foundation

struct CompanyInfo {
    let companyName: String
    let founderName: String
    let year: Int
    let employees: Int
    let launchSites: Int
    let valuation: Int
}

class CompanyInfoViewModel {
    
    private let service: ClientRepository
    
    private var companyInfo: CompanyInfo?
    
    private var error: ClientRepository.APIError?
    
    init(service: ClientRepository) {
        self.service = service
    }
    
    func update() {
        service.getCompanyInfo { result in
            switch result {
            case .success(let companyInfo):
                self.companyInfo = companyInfo.toCompanyInfo()
            case .failure(let error):
                self.error = error
            }
        }
    }
}

extension ClientRepository.CompanyInfo {
    func toCompanyInfo() -> CompanyInfo {
        return .init(companyName: name,
                     founderName: founder,
                     year: founded,
                     employees: employees,
                     launchSites: launchSites,
                     valuation: valuation)
    }
}
