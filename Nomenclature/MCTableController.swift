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
    let organismCardFactory = OrganismCardFactory()
    var receivedCollection: Collection?
    
    var myCollection: [OrganismCard]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setMyCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        if myCollection == nil {
//            let msg = "Nothing to see here! Why don't you go search for something."
//            let alert = UIAlertController(title: "No Saved Items", message: msg, preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            alert.addAction(alertAction)
//            navigationController?.present(alert, animated: true, completion: {
//                DispatchQueue.main.async {
//                    // self.navigationController?.popViewController(animated: false)
//                    self.navigationController?.popToRootViewController(animated: false)
//                }
//            })
//        }
        
    }
    
    // IBActions
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "tableAddCard", sender: self)
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableAddCard" {
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! SearchController
            vc.receivedCollection = receivedCollection
        }
    }
    
    func setMyCollection() {
        guard let thisCollection = receivedCollection else {
            print("collection missing")
            return
        }
        
        guard let organisms = thisCollection.hasOrganism?.allObjects as? [Organism] else {
            return
        }
        
        myCollection = organismCardFactory.createCardArray(organismArray: organisms)
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
        
        if (indexPath.row % 2) == 0 {
            cell.backgroundColor = UIColor.lightGray
        }
        
        guard let card = myCollection?[indexPath.row] else {
            cell.vernacularTextField.text = "Name Missing!"
            return cell
        }
        
        guard let firstName = card.fetchFirstCommonName(language: "english") else {
            cell.vernacularTextField.text = "Name Missing!"
            return cell
        }
        

        cell.vernacularTextField.text = firstName.name
        return cell
    }
}
