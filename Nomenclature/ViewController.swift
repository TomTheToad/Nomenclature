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
        
        itis.commonNameSearch(commonName: "owl", numberOfRecords: 10, completionHandler: {
        (error, dict) in
            if error == nil {
                guard let thisDict = dict else {
                    print("Error dict")
                    return
                }
                
                for record in thisDict {
                    for item in record {
                        print("key: \(item.key), value: \(item.value)")
                    }
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
