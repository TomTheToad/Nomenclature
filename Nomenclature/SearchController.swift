//
//  SearchController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

/*
 
 First, and currently only, means of adding an organism card to the library.
 The user is prompted to search ITIS.gov database by common name
 
 This search is EXTREMELY case and spelling sensitive.
 
 */

// TODO: list:
// 1) add cancel [done]
// 2) update search to include capitalized and noncapitalized query
// 3) create cards later, eliminate some processing overhead?
// 4) Add other search methods, i.e. fuzzy, species names, etc.

import UIKit

class SearchController: UIViewController, UITextFieldDelegate {
    
    // Dependencies
    let itis = ITISAPIController()
    let coreData = CoreDataController()
    
    // Fields
    // Default number of records returned in a search
    var numberOfRecords = 10
    var receivedCollection: Collection?
    
    // Cards generated for future use.
    var organismCards = [OrganismCard]() {
        didSet {
            performResultsSeque(sender: self)
        }
    }
    
    // IBOutlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        searchField.delegate = self
        searchField.becomeFirstResponder()
    }
    
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
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        activityIndicator.startAnimating()
        searchITIS()
    }
    
    // Call to ITISAPIController to initiate search.
    func searchITIS() {
        guard let searchText = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            activityIndicator.stopAnimating()
            print("nothing to search")
            GenericAlert(message: "Please enter something to search")
            return
        }
        
        itis.commonNameSearch(commonName: searchText, numberOfRecords: numberOfRecords, completionHandler: {
            (error, dict) in
            if error == nil {
                guard let organismsDict = dict else {
                    self.GenericAlert()
                    return
                }
                
                guard let collection = self.receivedCollection else {
                    self.GenericAlert()
                    return
                }
                
                var cardsArray = [OrganismCard]()
                for recordDict in organismsDict {
                    let card = OrganismCard(collection: collection, taxonomicData: recordDict)
                    cardsArray.append(card)
                }
                
                if cardsArray.count <= 0 {
                    self.GenericAlert(message: "Your search did not return any results. Please note search terms are case sensitive. Please try again.")
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.organismCards = cardsArray
                    }
                }
                
            } else {
                self.GenericAlert()
            }
        })
    }
    
    // Keyboard: add return key "go" functionality
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchITIS()
        return true
    }
    
    // Navigation
    func performResultsSeque(sender: Any?) {
        performSegue(withIdentifier: "searchResultsSeque", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultsSeque" {
            let searchResultsController = segue.destination as! SearchResultsTableController
            searchResultsController.organismCards = organismCards
        }
    }
    
    // Generic user alert
    func GenericAlert(message: String? = nil) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let thisMessage = message ?? "Oops, your request failed. Please check your connection and try again."
            let alert = OKAlertGenerator(alertMessage: thisMessage)
            self.present(alert.getAlertToPresent(), animated: false, completion: nil)
        }
    }
}
