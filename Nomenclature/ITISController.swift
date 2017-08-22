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
    
    let baseURL = "https://services.itis.gov/?q="
    let methodCallCommonName = "vernacular:"
    
    
    func commonNameSearch2(commonName: String, numberOfRecords: Int, completionHandler: @escaping (Error?, [NSDictionary]?)->Void) {
        
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
        // print("url: \(urlComponents.url!)")
        
        guard let url = urlComponents.url else {
            print("Error: url missing")
            return
        }
        
        // create request
        // TODO: Handle time out
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 1.0)
        
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
            
            var thisRecordArray = [String: String]()
            
            // retrieve ojbect with common (vernacular) name
            guard let commonNameArray = record.object(forKey: "vernacular") as? NSArray else {
                print("unable to locate common name")
                return nil
            }
            
            for item in commonNameArray {
                print("common name: \(item)")
            }
            
            // print("common name: \(commonNameArray)")
            guard let firstNameObject = commonNameArray.firstObject as? NSString else {
                print("commonName string missing")
                return nil
            }
            
            let commonNameDataString = firstNameObject.components(separatedBy: "$")
            
            let firstCommonName = commonNameDataString[1]
            
            thisRecordArray["vernacular"] = firstCommonName
            
            
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

enum ITISControllerErrors: Error {
    case noDataReturned
}
