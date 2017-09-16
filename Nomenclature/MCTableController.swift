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
    var myCollection: [Organism]? = {
        let coreData = CoreDataController()
        guard let results = coreData.fetchAll() else {
            print("no results")
            return nil
        }
        return results
        }()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // IBActions
    @IBAction func addButton(_ sender: Any) {
        addCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if myCollection == nil {
            let msg = "Nothing to see here! Why don't you go search for something."
            let alert = UIAlertController(title: "No Saved Items", message: msg, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            navigationController?.present(alert, animated: true, completion: {
                DispatchQueue.main.async {
                    // self.navigationController?.popViewController(animated: false)
                    self.navigationController?.popToRootViewController(animated: false)
                }
            })
        }
        
        // testWM()
        // testINaturalist()
        // testFlikr()
    }
    
    // Test Methods
    func testFlikr() {
        let flikr = FlickrAPIController()
        do {
            try flikr.getImageArray(textToSearch: "alaskan,malamute", completionHander: {
                (error, dict) in
                if error == nil {
                    guard let dict = dict else {
                        print("flikr dict empty")
                        return
                    }
                    
                    for image in dict {
                        for item in image {
                           print("key: \(item.key), value: \(item.value)")
                        }
                    }
                } else {
                    print("flikr error: \(error!)")
                }
        })
        } catch {
            print("flikr failure")
        }
    }
    
    func testWM() {
        let wm = WikimediaAPIController()
        wm.testWM()
    }
    
    func testINaturalist() {
        let iNat = INaturalListAPIController()
        iNat.performQuery(query: "blue whale", numberOfItemsPerPage: 40, completionHander: {
            (error, dict) in
            if error == nil {
                guard let firstItem = dict?.first else {
                    print("first item missing")
                    return
                }
                
                for item in firstItem {
                    print("key: \(item.key), value: \(item.value)")
                }
            }
            else {
                print("error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    // Seque
    func addCard() {
        performSegue(withIdentifier: "tableAddCard", sender: self)
    }
    
    // MARK: Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = myCollection?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCTableCell", for: indexPath) as! MCTableCell
        
        guard let organism = myCollection?[indexPath.row] else {
            cell.vernacularTextField.text = "Name Missing!"
            return cell
        }

        cell.vernacularTextField.text = organism.vernacular
        return cell
    }
}
