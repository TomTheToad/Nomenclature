//
//  ITISController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/1/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation

class ITISController: NSObject {

    let returnFormat = "json"
    let session = URLSession(configuration: .ephemeral)
    
    let baseUrl = "https://services.itis.gov/"
    let methodCall = "?q=vernacular:"
//    let urlString = "https://services.itis.gov/?q=vernacular:*\(commonName)*&rows=\(numberRows)&wt=\(returnFormat)"
    
    func commonNameSearch(commonName: String, numberOfRecords: Int, completionHandler: @escaping (Error?, [NSDictionary]?)->Void) {
        let urlString = baseUrl + methodCall + "*\(commonName)*&rows=\(String(numberOfRecords))&wt=\(returnFormat)"
        print("urlString: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("url failure")
            return
        }
        print("url: \(String(describing: url))")
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
        (data, response, error) in
            if error != nil {
                completionHandler(error, nil)
            } else {
                // TODO: check response
                print("response: \(response!.description)")
                
                guard let returnData = self.ConvertJSONToDict(data: data) else {
                    print("serialization problem")
                    completionHandler(ITISControllerErrors.noDataReturned, nil)
                    return
                }
                
                completionHandler(nil, returnData)
                
            }
        })
        
        task.resume()
    }
    
    func ConvertJSONToDict(data: Data?) -> [NSDictionary]? {
        guard let data = data else {
            print("missing data")
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            
            guard let dict = jsonData.object(forKey: "response") as? NSDictionary else {
                print("JSON conversion error")
                return nil
            }
            
            guard let docsArray = dict.object(forKey: "docs") as? [NSDictionary] else {
                print("Error locating docs key")
                return nil
            }
            
            return docsArray
            
        } catch {
            return nil
        }
    }

}

enum ITISControllerErrors: Error {
    case noDataReturned
}

/* 
 
http://services.itis.gov/?q=vernacular:*lion*&rows=10&wt=json
 
 hierarchySoFar
 
 */
