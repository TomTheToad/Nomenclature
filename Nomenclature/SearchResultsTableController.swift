//
//  SearchResultsTableController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organismCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableCell", for: indexPath) as! SearchResultsTableCell
        let card = organismCards[indexPath.row]
        guard let firstCommonName = card.fetchFirstCommonName(language: "english") else {
            // TODO: handle error
            cell.commonNameLabel.text = "missing data"
            return cell
        }
        cell.commonNameLabel.text = firstCommonName.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
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
