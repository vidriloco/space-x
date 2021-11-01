//
//  ClientRepository+Models.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 30/10/2021.
//

import Foundation

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

    struct Launch: Decodable {
        struct Links: Decodable {
            let video: String?
            let youtubeId: String?
            let article: String?
            let wikipedia: String?
            let image: String?
            
            private enum CodingKeys: String, CodingKey {
                case video = "video_link"
                case article = "article_link"
                case image = "mission_patch_small"
                case youtubeId = "youtube_id"
                case wikipedia
            }
        }
        
        struct Rocket: Decodable {
            let name: String
            let type: String
            
            private enum CodingKeys: String, CodingKey {
                case name = "rocket_name"
                case type = "rocket_type"
            }
        }
        
        let missionName: String
        let date: Date
        let success: Bool?

        let links: Links
        let rocket: Rocket
        
        private enum CodingKeys: String, CodingKey {
            case missionName = "mission_name"
            case date = "launch_date_unix"
            case success = "launch_success"
            case links, rocket
        }
    }

}
