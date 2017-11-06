//
//  SearchResultsTableController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Table to display results from an ITIS search.
// TODO: add ability to search results

import UIKit

class SearchResultsTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Fields
    var organismCards = [OrganismCard]()
    
    // IBOutlets
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
    }

    // MARK: Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organismCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableCell", for: indexPath) as! SearchResultsTableCell
        let card = organismCards[indexPath.row]
        
        // Test for existing common name
        // Not all records will have a common name
        // TODO: find a better way of dealing with this? Possibly display another name
        // possibly check each taxonomic name and pick the most specific available.
        var name: String
        if let firstEnglishName = card.fetchFirstCommonName(language: "english") {
            name = firstEnglishName.name
        } else if let firstName = card.fetchFirstCommonName() {
            name = firstName.name
        } else {
            name = "common name missing"
        }
        
        cell.commonNameLabel.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            guard let indexRow = resultsTableView.indexPathForSelectedRow?.row else {
                // TODO: error handling
                print("index error")
                return
            }
            let vc = segue.destination as! DetailViewController
            vc.recievedOrganismCard = organismCards[indexRow]
        }
    }
}
