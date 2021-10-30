//
//  URLBuilder.swift
//  SpaceX Client
//
//  Created by Alejandro Cruz on 29/10/2021.
//

import Foundation

class URLBuilder {

    private var scheme : String
    private var host: String
    private var path: String
    private var params = [String: String]()

    var url : URL? {

        let urlComponents = NSURLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = params.map({ (key, value) -> NSURLQueryItem in
            return NSURLQueryItem(name: key, value: value)
        }) as [URLQueryItem]
        
        return urlComponents.url
    }

    init(scheme: String? = "https", host: String, path: String? = "") {
        self.scheme = scheme!
        self.path = path!
        self.host = host
    }

    func with(path: String) -> Self {
        self.path = path
        return self
    }

    func with(params: [String: String]) -> Self {
        self.params = params
        return self
    }

}
