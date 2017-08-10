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
    var resultsDict = [NSDictionary]()
    
    // IBOutlets
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableCell", for: indexPath) as! SearchResultsTableCell
        let dict = resultsDict[indexPath.row]
        
        guard let commonName: String = dict.value(forKey: "commonName") as? String else {
            return cell
        }
        
        cell.commonNameLabel.text = commonName
        return cell
    }
}
