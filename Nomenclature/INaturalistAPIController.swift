//
//  INaturalistAPIController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/28/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class INaturalListAPIController {
    private let baseURL = "api.inaturalist.org"
    private let path = "/v1/taxa/autocomplete"
    private var itemsPerPage = 10
    private let session = URLSession(configuration: .ephemeral)
    
    private func buildQueryItems(query: String, numItemPerPage: Int) -> [URLQueryItem] {
        let queryItems = [
            URLQueryItem.init(name: "q", value: query),
            URLQueryItem.init(name: "per_page", value: String(itemsPerPage))
        ]
        return queryItems
    }
    
    private func getURL(queryItems: [URLQueryItem]) throws -> URL {
        let urlBuilder = URLBuilder(baseURL: baseURL, path: path, queryItems: queryItems)
        guard let thisURL = urlBuilder.getURL() else {
            print("URL Builder error")
            throw INaturalListError.urlFailure
        }
        print("iNat URL: \(thisURL)")
        return thisURL
    }
    
    func performQuery(query: String, numberOfItemsPerPage: Int, completionHander: @escaping (Error?, [NSDictionary]?)->Void) {
        
        let queryItems = buildQueryItems(query: query, numItemPerPage: 20)
        
        guard let url = try? getURL(queryItems: queryItems) else {
            completionHander(INaturalListError.urlFailure, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 1.0)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            // TODO: determine nature of repsonse (not as expected)
            if error == nil {
                guard let data = data else {
                    completionHander(INaturalListError.dataMissing, nil)
                    return
                }
                
                guard let parsedData = self.convertJSONToDict(data: data) else {
                    completionHander(INaturalListError.jsonSerializationFailure, nil)
                    return
                }
                
                completionHander(nil, parsedData)
                
            } else {
                completionHander(error, nil)
            }
        })
        
        task.resume()
    }
    
    private func convertJSONToDict(data: Data) -> [NSDictionary]? {
        
        var jsonData: NSDictionary
        
        // attempt to set serialize json
        do {
            jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            
        } catch {
            print("JSON serialization failure iNat")
            return nil
        }
        
        guard let totalResults = jsonData.value(forKey: "total_results") as? Int else {
            print("no results returned from iNat")
            return nil
        }
        
        if totalResults > 0 {
            return jsonData.value(forKey: "results") as? [NSDictionary]
        }
        
        print("iNat: End of Line")
        return nil
    }
    
}

enum INaturalListError: Error {
    case urlFailure
    case reponseFailure
    case dataMissing
    case jsonSerializationFailure
}

