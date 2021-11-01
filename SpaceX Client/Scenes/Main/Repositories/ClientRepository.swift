//
//  CompanyInfoRepository.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 29/10/2021.
//

import Foundation
import UIKit

typealias GetCompanyInfoResponse = (Result<ClientRepository.CompanyInfo, ClientRepository.APIError>) -> Void
typealias GetLaunchesResponse = (Result<[ClientRepository.Launch], ClientRepository.APIError>) -> Void

// MARK: - ClientRepositable

protocol ClientRepositable {
    var hostURL: String { get }
    
    func getCompanyInfo(completion: @escaping GetCompanyInfoResponse)
    func getLaunches(ordering: String?, launchStatus: String?, year: String?, completion: @escaping GetLaunchesResponse)
}

// MARK: - ClientRepository

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
    
    func getLaunches(ordering: String? = nil,
                     launchStatus: String? = nil,
                     year: String? = nil,
                     completion: @escaping GetLaunchesResponse) {
        
        var params = [String: String]()
        if year != nil { params["launch_year"] = year }
        if ordering != nil { params["order"] = ordering }
        if launchStatus != nil { params["launch_success"] = launchStatus }
        
        guard let url = urlBuilder.with(path: "/v3/launches").with(params: params).url else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let unpackedError = error {
                completion(.failure(.loadingFailed(unpackedError.localizedDescription)))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            if let unpackedData = data,
               let launchesList = try? decoder.decode([Launch].self, from: unpackedData) {
                completion(.success(launchesList))
                return
            }
            
            completion(.failure(.malformedResponse))
        }
        
        task.resume()
    }
    
    private lazy var urlBuilder = { URLBuilder(host: hostURL) }()
}
