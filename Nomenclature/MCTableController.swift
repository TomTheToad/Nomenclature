//
//  MCTableController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/22/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Fields
    let coreData = CoreDataController()
    var myCollection = [Organism]()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionData = coreData.fetchAll() {
            myCollection = collectionData
            tableView.reloadData()
        } else {
            let msg = "Nothing to see here! Why don't you go search for something."
            let alert = UIAlertController(title: "No Saved Items", message: msg, preferredStyle: .alert)
            present(alert, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: false)
            })
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCTableCell", for: indexPath) as! SearchResultsTableCell
        cell.commonNameLabel.text = myCollection[indexPath.row].vernacular
        return cell
    }
}
