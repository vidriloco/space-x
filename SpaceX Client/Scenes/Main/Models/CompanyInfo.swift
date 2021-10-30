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
