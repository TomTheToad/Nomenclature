//
//  ViewController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/1/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let itis = ITISController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itis.commonNameSearch(commonName: "raven", numberOfRecords: 10, completionHandler: {
        (error, dict) in
            if error == nil {
                guard let docArray = dict else {
                    print("Something wrong")
                    return
                }
                
                guard let firstEntry = docArray.first else {
                    print("first entry missing")
                    return
                }
                
                guard let hierarchy = firstEntry.object(forKey: "hierarchySoFarWRanks") as? NSArray else {
                    print("hierarchy not found")
                    return
                }
                
                guard let firstObject = hierarchy.firstObject as? NSString else {
                    print("H first object missing")
                    return
                }
                
                print("firstObject: \(firstObject)")
                
                let newString = NSMutableString(string: firstObject).trimmingCharacters(in: CharacterSet(charactersIn: "0123456789")).components(separatedBy: "$")
                
                var newArray = [String: String]()
                for item in newString {
                    let newItem = item.components(separatedBy: ":")
                    newArray[newItem.first!] = newItem.last!
                }
                
                let finalArray = newArray.dropFirst()
                
                for item in finalArray {
                    print("key: \(item.key), value: \(item.value)")
                }
                
                
                
                
                
            } else if error != nil {
                print("error: \(error!.localizedDescription)")
                if let thisDict = dict {
                    print("thisDict: \(thisDict)")
                }
            }
        })
    }
}
