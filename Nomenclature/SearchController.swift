//
//  SearchController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    // Fields
    let itis = ITISController()
    var numberOfRecords = 10
    
    // IBOutlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // IBActions
    @IBAction func selectNumberRecordsAction(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 1 {
            numberOfRecords = 50
        } else if index == 2 {
            numberOfRecords = 100
        } else {
            numberOfRecords = 10
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        guard let searchText = searchField.text else {
            print("Please enter something to search")
            return
        }
        
        itis.commonNameSearch(commonName: searchText, numberOfRecords: numberOfRecords, completionHandler: {
            (error, dict) in
            if error == nil {
                guard let thisDict = dict else {
                    print("Error dict")
                    return
                }
                
                DispatchQueue.main.async {
                    self.presentSearchResults(resultsDict: thisDict)
                }
                
            } else if error != nil {
                print("error: \(error!.localizedDescription)")
                if let thisDict = dict {
                    print("thisDict: \(thisDict)")
                }
            }
        })
    }
    
    func presentSearchResults(resultsDict: [NSDictionary]) {
        
        let searchResultsTableController = storyboard?.instantiateViewController(withIdentifier: "searchResultsTable") as! SearchResultsTableController
        
        searchResultsTableController.resultsDict = resultsDict
        navigationController?.present(searchResultsTableController, animated: false, completion: nil)
    }
    
}
