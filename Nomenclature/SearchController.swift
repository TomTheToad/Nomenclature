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
    let itis = ITISAPIController()
    let coreData = CoreDataController()
    var numberOfRecords = 10
    var receivedCollection: Collection?
    
    var resultsDict = [NSDictionary]() {
        didSet {
            performResultsSeque(sender: self)
        }
    }
    
    // IBOutlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // IBActions
    @IBAction func selectNumberRecordsAction(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 1 {
            numberOfRecords = 50
        } else if index == 2 {
            numberOfRecords = 100
        } else if index == 3 {
            numberOfRecords = 500
        } else {
            numberOfRecords = 10
        }
    }
    
    @IBAction func myCollectionButtonAction(_ sender: Any) {
        performMCSeque(sender: self)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchITIS()
    }
    
    func searchITIS() {
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
                    self.resultsDict = thisDict
                }
                
            } else if error != nil {
                print("error: \(error!.localizedDescription)")
                if let thisDict = dict {
                    print("thisDict: \(thisDict)")
                }
            }
        })
    }
    
    func performMCSeque(sender: Any?) {
        // TODO: perform seque to initialVC
    }
    
    func performResultsSeque(sender: Any?) {
        performSegue(withIdentifier: "searchResultsSeque", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultsSeque" {
            let searchResultsController = segue.destination as! SearchResultsTableController
            searchResultsController.resultsDict = resultsDict
            searchResultsController.receivedCollection = receivedCollection
        }
    }
}
