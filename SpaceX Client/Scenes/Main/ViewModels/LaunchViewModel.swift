//
//  LaunchViewModel.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 30/10/2021.
//

import Foundation
import UIKit

final class LaunchViewModel {
    private let launch: Launch
    
    var missionLabelText = "Mission: "
    
    var missionLabelValue: String {
        launch.missionName
    }
    
    var dateLabelText = "Date/time: "

    var dateLabelValue: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: launch.date)
    }
    
    var rocketLabelText = "Rocket: "
    
    var rocketLabelValue: String {
        guard let rocketName = launch.name,
              let rocketType = launch.type else {
                  if let rocketName = launch.name { return rocketName }
                  if let rocketType = launch.type { return rocketType }
                  
                  return "Not available"
        }
        
        return "\(rocketName) / \(rocketType)"
    }
    
    var daysLabelText: String {
        return launch.date < Date() ? "Days since now: " : "Days from now: "
    }
    
    var daysLabelValue: String {
        let calendar = Calendar.current

        guard let days = calendar.dateComponents([.day], from: launch.date, to: Date()).day else {
            return "Unknown"
        }
        
        return days.formatted()
    }
    
    var missionPatchImageURL: String? {
        return launch.imageURL
    }
    
    var missionStatusImage: UIImage? {
        return launch.missionSuccessful ? UIImage(named: "success-icon") : UIImage(named: "failure-icon")
    }
    
    var articleURL: String? {
        launch.articleURL
    }
    
    var videoURL: String? {
        launch.videoURL
    }
    
    var wikipediaURL: String? {
        launch.wikipediaURL
    }
    
    var youtubeIdURL: String? {
        guard let youtubeID = launch.youtubeID else { return nil }
        return "youtube://\(youtubeID)"
    }
    
    public init(with launch: Launch) {
        self.launch = launch
    }
}
