//
//  SearchController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

// TODO: list:
// 1) add cancel
// 2) update search to include capitalized and noncapitalized query
// 3) create cards later, eliminate some processing overhead?

import UIKit

class SearchController: UIViewController {
    
    // Fields
    let itis = ITISAPIController()
    let coreData = CoreDataController()
    
    var numberOfRecords = 10
    var receivedCollection: Collection?
    
    var organismCards = [OrganismCard]() {
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
                guard let organismsDict = dict else {
                    print("Error dict")
                    return
                }
                
                guard let collection = self.receivedCollection else {
                    print("Error collection")
                    return
                }
                
                var cardsArray = [OrganismCard]()
                for recordDict in organismsDict {
                    let card = OrganismCard(collection: collection, taxonomicData: recordDict)
                    cardsArray.append(card)
                }
                
                DispatchQueue.main.async {
                    self.organismCards = cardsArray
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
            searchResultsController.organismCards = organismCards
        }
    }
}
