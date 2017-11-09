//
//  MCTableController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/22/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Table View of organisms within a collection.

import UIKit

class MCTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Dependencies
    let coreData = CoreDataController()
    let organismCardFactory = OrganismCardFactory()
    var receivedCollection: Collection?
    
    // Fields
    var myCollection: [OrganismCard]? {
        didSet {
            // Check for editing to allow for animated removal vs reload.
            if isEditing == false {
                tableView.reloadData()
            }
        }
    }
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // IBActions
    @IBAction func addButton(_ sender: Any) {
        addCard()
    }
    
    // View triggered events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setMyCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    // Data Methods
    func setMyCollection() {
        guard let thisCollection = receivedCollection else {
            print("collection missing")
            return
        }
        
        guard let organisms = coreData.fetchAllOrganismsInCollection(collection: thisCollection) else {
            return
        }
        
        myCollection = organismCardFactory.createCardArray(organismArray: organisms)
    }
    
    // Delete an item and remove from view
    func deleteItemAtIndex(indexPath: IndexPath) {
        guard let card = myCollection?[indexPath.row] else {
            print("No card to delete")
            return
        }
        
        guard let id = card.id else {
            print("id missing")
            return
        }
        
        let isSuccess = coreData.deleteOrganism(id: id)
        isEditing = true
        let alertGen = OKAlertGenerator(alertMessage: "Oops, Unable to Delete Item. Please try again")
        if isSuccess {
            alertGen.message = "Item deleted"
            alertGen.title = "Success"
        }
        present(alertGen.getAlertToPresent(), animated: true, completion: nil)
        
        setMyCollection()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        isEditing = false
    }
    
    // MARK: Table Methods
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = nil
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.allowsSelection = false

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            guard let count = myCollection?.count else {
                return 0
            }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Check for delete interation and that swipe does not include section for adding an item.
        // Note this an extra precaution as the below method should prevent editing at all.
        if editingStyle == .delete && indexPath.section != 1 {
            deleteItemAtIndex(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Disallow edit of functional "Add Item" cell.
        if indexPath.section == 1 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCTableCell", for: indexPath) as! MCTableCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
        }
        
        if indexPath.section == 1 {
            cell.vernacularTextField.text = "Add Organism"
            cell.speciesTextField.isHidden = true
            cell.cardImage.image = #imageLiteral(resourceName: "add")
            cell.vernacularTextField.textColor = UIColor.orange
            return cell
        } else {
            guard let card = myCollection?[indexPath.row] else {
                cell.vernacularTextField.text = "Card Missing!"
                return cell
            }
            
            if let photo = card.photo {
                if let thumb = photo.thumbImage {
                    cell.cardImage.image = thumb
                } else {
                    cell.cardImage.image = #imageLiteral(resourceName: "defaultImage")
                }
            }
            
            if let id = card.id {
                cell.id = id
            }
            cell.vernacularTextField.textColor = UIColor.black
            cell.speciesTextField.isHidden = false
            cell.vernacularTextField.text = card.fetchFirstCommonName(language: "english")?.name ?? "no data"
            cell.speciesTextField.text = card.species ?? "no data"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            addCard()
        }
    }
    
    // MARK: Navigation
    func addCard() {
        performSegue(withIdentifier: "tableAddCard", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableAddCard" {
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! SearchController
            vc.receivedCollection = receivedCollection
        }
    }
}
