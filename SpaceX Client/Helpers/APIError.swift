//
//  APIError.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 29/10/2021.
//

import Foundation

// MARK - Error

enum APIError: Error, ReportableError {
    var detailed: String {
        switch self {
        case .malformedURL:
            return "The provided URL is malformed"
        }
    }

    case malformedURL
}

// MARK - An enum for handling API responses

protocol ReportableError {
    var detailed : String { get }
}
