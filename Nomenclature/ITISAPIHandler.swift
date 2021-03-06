//
//  ITISAPIHandler.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/1/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Specialized class to handle interaction with ITIS.gov api

import Foundation

class ITISAPIHandler: NSObject {

    // Fields
    let returnFormat = "json"
    let session = URLSession(configuration: .ephemeral)
    
    // Base method item defaults
    let baseURL = "https://services.itis.gov/?q="
    let methodCallCommonName = "vernacular:"
    
    // Search ITIS.gov database by common name.
    // This search is VERY case and spelling sensitive.
    func commonNameSearch(commonName: String, numberOfRecords: Int, completionHandler: @escaping (Error?, [NSDictionary]?)->Void) {
        
        let baseString = "services.itis.gov"
        let method = "vernacular:"
        let searchString = parseSearchString(searchString: commonName)
        
        let queryItems = [
            
            URLQueryItem.init(name: "q", value: method + searchString),
            URLQueryItem.init(name: "rows", value: String(describing: numberOfRecords)),
            URLQueryItem.init(name: "wt", value: "json")
        ]
        
        // url components build out
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.path = "/"
        urlComponents.host = baseString
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Error: url missing")
            return
        }
        
        // create request
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
        
        // create session
        let session = URLSession.shared
        
        // create task
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            if error != nil {
                completionHandler(error, nil)
            } else {
                // TODO: check response
                guard let returnData = self.ConvertJSONToDict(data: data) else {
                    print("serialization problem")
                    completionHandler(ITISControllerErrors.noDataReturned, nil)
                    return
                }
                
                completionHandler(nil, returnData)
            }
        }
        // resume task
        task.resume()
    }
    
    // Parse user supplied search string to prepare for submission
    func parseSearchString(searchString: String) -> String {
        var arguments = "*"
        
        if searchString.contains(" ") {
            let commonNameMultipleWords = searchString.components(separatedBy: " ")
            for item in commonNameMultipleWords {
                if item != commonNameMultipleWords.last {
                    arguments = arguments + "\(item)\\ "
                } else {
                    arguments = arguments + "\(item)*"
                }
            }
        } else {
            arguments = arguments + "\(searchString)*"
        }
        
        return arguments
    }
    
    // Convert JSON data to an NSDictionary
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
            
            guard let returnDict = parseDictInfo(dict: docsArray) else {
                print("Error: parseDictInfo")
                return nil
            }
            
            return returnDict
            
        } catch {
            return nil
        }
    }
    
    // TODO: return a collection with necessary data
    // heirarchy, common name,
    func parseDictInfo(dict: [NSDictionary]) -> [NSDictionary]? {
        
        var recordsDict = [NSDictionary]()
        
        for record in dict {
            
            var thisRecordArray = [String: Any]()
            
            // retrieve ojbect with common (vernacular) name
            guard let commonNameArray = record.object(forKey: "vernacular") as? NSArray else {
                print("unable to locate common name")
                return nil
            }
            
            // Create an array of tuples to store common names and associated languages.
            var nameArray = [(name: String, language: String)]()
            for data in commonNameArray {
                guard let nameAsString = data as? NSString else {
                    print("name missing in common name array")
                    return nil
                }
                
                let name = nameAsString.components(separatedBy: "$")
                nameArray.append((name[1].lowercased(), name[2].lowercased()))
            }

            thisRecordArray["vernacular"] = nameArray
            
            
            // retrieve object for key "hierarchySoFarWRanks"
            guard let hierarchy = record.object(forKey: "hierarchySoFarWRanks") as? NSArray else {
                print("hierarchy not found")
                return nil
            }
            
            // object search returns an NSArray of one item. Get first object as NSString
            guard let firstHierarchyObject = hierarchy.firstObject as? NSString else {
                print("H first object missing")
                return nil
            }
            
            // remove any numbers and convert php style variables to a delineated string
            let dataString = NSMutableString(string: firstHierarchyObject).trimmingCharacters(in: CharacterSet(charactersIn: "0123456789")).components(separatedBy: "$")
            
            // last string separation and add key, value to recordsArray
            for item in dataString {
                let newItem = item.components(separatedBy: ":")
                // TODO: test for nil?
                thisRecordArray[newItem.first!.lowercased()] = newItem.last!
            }
            
            recordsDict.append(thisRecordArray as NSDictionary)
            
        }
        
        return recordsDict
    }

}

// Errors
enum ITISControllerErrors: Error {
    case noDataReturned
}
