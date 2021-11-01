//
//  Launch.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 28/10/2021.
//

import Foundation

struct Launch {
    let missionName: String
    let date: Date
    let name: String?
    let type: String?
    let missionSuccessful: Bool
    
    let imageURL: String?
    let videoURL: String?
    let articleURL: String?
    let wikipediaURL: String?
    let youtubeID: String?
}

extension ClientRepository.Launch {
    func toLaunch() -> Launch {
        
        return .init(missionName: missionName,
                     date: date,
                     name: rocket.name,
                     type: rocket.type,
                     missionSuccessful: success ?? false,
                     imageURL: links.image,
                     videoURL: links.video,
                     articleURL: links.article,
                     wikipediaURL: links.wikipedia,
                     youtubeID: links.youtubeId)
    }
}
