//
//  WikimediaAPIController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/12/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class WikimediaAPIController {
    
    var baseURL = "en.wikipedia.org"
    var path = "/w/api.php"
    
    var urlQueryItems: [URLQueryItem] = [
        
        URLQueryItem(name: "action", value: "query"),
        URLQueryItem(name: "prop", value: "extracts"),
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "exintro", value: ""),
        URLQueryItem(name: "titles", value: "alaskan_malamute")
        
    ]
    
    func testWM() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURL
        urlComponents.path = path
        urlComponents.queryItems = urlQueryItems
        print(urlComponents.url!)
        
        // en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=Stack%20Overflow
        //https://www.mediawiki.org/wiki/API:Page_info_in_search_results
        
        let request = URLRequest(url: urlComponents.url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 6.0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error == nil {
                print("response: \(response!)")
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    for item in jsonResult {
                        print("key: \(item.key), value: \(item.value)")
                    }
                } catch {
                    print("JSON serialization failed")
                }
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            
        })
        
        task.resume()
    }
}
