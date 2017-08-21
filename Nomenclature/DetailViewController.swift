//
//  DetailViewController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/12/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Fields
    var organismData = NSDictionary()
    let headings = ["vernacular", "kingdom", "phylum", "class", "order", "suborder", "family", "genus", "species"]
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as? DetailViewCell else {
            fatalError("table cell error")
        }
        
        let heading = headings[indexPath.row]
        let name = organismData.value(forKey: heading) ?? "missing data"
        
        cell.headingLabel.text = heading
        cell.nameLabel.text = String(describing: name)
        
        return cell
    }
}
