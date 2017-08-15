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
    let methodCall = "vernacular:"
    
    
//    func commonNameSearch2(commonName: String, numberOfRecords: Int, completionHandler: @escaping (Error?, [NSDictionary]?)->Void) {
//        
//        guard let url = URL(string: (baseURL + methodCall)) else {
//            print("url failure")
//            return
//        }
//        
//        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 3.0)
//        request.httpMethod = "GET"
//        request.httpBody = "*\(commonName)*&rows=\(String(numberOfRecords))&wt=\(returnFormat)"
//    }
    
    func commonNameSearch(commonName: String, numberOfRecords: Int, completionHandler: @escaping (Error?, [NSDictionary]?)->Void) {
        
        var methodWString = ""
        
        // https://services.itis.gov/?q=vernacular:*morning*AND?q=vernacular:*dove*&rows=100&wt=json
        // http://services.itis.gov/?q=vernacular:*red*%20AND%20vernacular:*fox*&rows=10&wt=json
        // URL: https://services.itis.gov/?q=vernacular:*red*%20AND%20?q=vernacular:*fox*&rows=100&wt=json
        if commonName.contains(" ") {
            let commonNameMultipleWords = commonName.components(separatedBy: " ")
            for item in commonNameMultipleWords {
                if item != commonNameMultipleWords.last {
                    methodWString = methodWString + methodCall + "*\(item)*%20AND%20"
                } else {
                    methodWString = methodWString + methodCall + "*\(item)*"
                }
            }
        } else {
            methodWString = methodCall + "*\(commonName)*"
        }
        
        let urlString = baseURL + methodWString + "&rows=\(String(numberOfRecords))&wt=\(returnFormat)"
        print("urlString: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("url failure")
            return
        }
        
        print("URL: \(url)")
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
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
            
//            print("### Begin ParsedJSON ###")
//            print(jsonData)
//            print("### End ParsedJSON ###")
            
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
            
            // print("common name: \(commonNameArray)")
            guard let firstNameObject = commonNameArray.firstObject as? NSString else {
                print("commonName string missing")
                return nil
            }
            
            let commonNameDataString = firstNameObject.components(separatedBy: "$")
            
            for item in commonNameDataString {
                print("item: \(item)")
            }
            
            let firstCommonName = commonNameDataString[1]
            
            thisRecordArray["commonName"] = firstCommonName
            
            
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
                thisRecordArray[newItem.first!] = newItem.last!
            }
            
            recordsDict.append(thisRecordArray as NSDictionary)
            
        }
        
//        print("### Heirarchy ###")
//        for item in recordsDict {
//            print("keys: \(item.allKeys), values: \(item.allValues)")
//        }
        
        return recordsDict
    }

}

enum ITISControllerErrors: Error {
    case noDataReturned
}

/*
 
http://services.itis.gov/?q=vernacular:*lion*&rows=10&wt=json
 
 hierarchySoFar
 
 */
