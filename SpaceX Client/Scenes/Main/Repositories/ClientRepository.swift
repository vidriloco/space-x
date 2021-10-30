//
//  CompanyInfoRepository.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 29/10/2021.
//

import Foundation
import UIKit

typealias GetCompanyInfoResponse = (Result<ClientRepository.CompanyInfo, ClientRepository.APIError>) -> Void

protocol ClientRepositable {
    var hostURL: String { get }
    
    func getCompanyInfo(completion: @escaping GetCompanyInfoResponse)
}


class ClientRepository: ClientRepositable {

    var hostURL: String { "api.spacexdata.com" }
    
    func getCompanyInfo(completion: @escaping GetCompanyInfoResponse) {
        guard let url = urlBuilder.with(path: "/v3/info").url else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let unpackedError = error {
                completion(.failure(.loadingFailed(unpackedError.localizedDescription)))
                return
            }
            
            if let unpackedData = data,
               let companyInfo = try? JSONDecoder().decode(CompanyInfo.self, from: unpackedData) {
                completion(.success(companyInfo))
                return
            }
            
            completion(.failure(.malformedResponse))
        }
        
        task.resume()
    }
    
    private lazy var urlBuilder = { URLBuilder(host: hostURL) }()

}

extension ClientRepository {
    enum APIError: Error {
        case loadingFailed(String)
        case malformedResponse
    }
    
    struct CompanyInfo: Decodable {
        let name: String
        let founder: String
        let founded: Int
        let employees: Int
        let launchSites: Int
        let valuation: Int
        
        private enum CodingKeys: String, CodingKey {
            case launchSites = "launch_sites"
            case name, founder, founded, employees, valuation
        }
    }

}
