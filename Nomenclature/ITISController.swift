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
            
            print("### Begin ParsedJSON ###")
            print(jsonData)
            print("### End ParsedJSON ###")
            
            guard let dict = jsonData.object(forKey: "response") as? NSDictionary else {
                print("JSON conversion error")
                return nil
            }
            
            guard let docsArray = dict.object(forKey: "docs") as? [NSDictionary] else {
                print("Error locating docs key")
                return nil
            }
            
            print("count = \(docsArray.count)")
            
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
            
            print("common name: \(commonNameArray)")
            guard let firstNameObject = commonNameArray.firstObject as? NSString else {
                print("commonName string missing")
                return nil
            }
            
            let commonNameDataString = firstNameObject.components(separatedBy: "$")
            
            for item in commonNameDataString {
                print("item: \(item)")
            }
            
            let firstCommonName = commonNameDataString[1]
            
            print("firstCommonName: \(firstCommonName)")
            
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
