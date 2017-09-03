//
//  EOLAPI.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/2/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

//  eol.org/api/search/1.0.json?q=Ursus&page=1&exact=false&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=

import UIKit

class EOLAPI {
    
    private let baseURL = "eol.org"
    private let path = "/api/search/1.0.json"
    private var itemsPerPage = 10
    private let session = URLSession(configuration: .ephemeral)
    
    private func buildQueryItems(query: String, numItemPerPage: Int) -> [URLQueryItem] {
        let queryItems = [
            URLQueryItem.init(name: "q", value: query),
            URLQueryItem.init(name: "exact", value: "false")
        ]
        return queryItems
    }
    
    private func getURL(queryItems: [URLQueryItem]) throws -> URL {
        let urlBuilder = URLBuilder(baseURL: baseURL, path: path, queryItems: queryItems, secureScheme: false)
        guard let thisURL = urlBuilder.getURL() else {
            print("URL Builder error")
            throw EOLError.urlFailure
        }
        print("EOL URL: \(thisURL)")
        return thisURL
    }
    
    func performQuery(query: String, completionHander: @escaping (Error?, [NSDictionary]?)->Void) {
        
        let queryItems = buildQueryItems(query: query, numItemPerPage: 20)
        
        guard let url = try? getURL(queryItems: queryItems) else {
            completionHander(EOLError.urlFailure, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 1.0)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            // TODO: determine nature of repsonse (not as expected)
            if error == nil {
                guard let data = data else {
                    completionHander(EOLError.dataMissing, nil)
                    return
                }
                
                guard let parsedData = self.convertJSONToDict(data: data) else {
                    completionHander(EOLError.jsonSerializationFailure, nil)
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
            print("no results returned from EOL")
            return nil
        }
        
        if totalResults > 0 {
            return jsonData.value(forKey: "results") as? [NSDictionary]
        }
        
        print("EOL: End of Line")
        return nil
    }
    
}

enum EOLError: Error {
    case urlFailure
    case reponseFailure
    case dataMissing
    case jsonSerializationFailure
}
