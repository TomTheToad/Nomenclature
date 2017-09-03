//
//  URLBuilder.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/29/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation

class URLBuilder: NSObject {
    var baseURL = String()
    var path = String()
    var queryItems = [URLQueryItem]()
    var secureScheme = true
    
    init(baseURL: String, path: String, queryItems: [URLQueryItem], secureScheme: Bool = true) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
        
    }
    
    private func buildURL() -> URL? {
        
        var urlComponents = URLComponents()
        if secureScheme != true {
            urlComponents.scheme = "https"
        } else {
            urlComponents.scheme = "http"
        }
        urlComponents.host = baseURL
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        print("url: \(urlComponents.url!)")
        
        return urlComponents.url
    }
    
    func getURL() -> URL? {
        guard let url = buildURL() else {
            return nil
        }
        print("URLBuilder: \(url)")
        return url
    }
    
}
