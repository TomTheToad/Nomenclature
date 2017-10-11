//
//  MCCollectionController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/24/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Fields
    let coreData = CoreDataController()
    var receivedCollection: Collection?
    var organismCardFactory = OrganismCardFactory()

    var myCollection: [OrganismCard]? {
        didSet {
            mcCollection.reloadData()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var mcCollection: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        setMyCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mcCollection.delegate = self
        mcCollection.dataSource = self
        mcCollection.isPagingEnabled = true
        
        testReceivedCollection()
        
        
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
    @IBAction func addCardButton(_ sender: Any) {
        performSegue(withIdentifier: "collectionAddCard", sender: self)
    }
    
    @IBAction func deleteCardButton(_ sender: Any) {
        deleteCardShown()
    }
    
    // Test methods
    func testReceivedCollection() {
        if receivedCollection != nil {
            print("receivedCollection: not nil")
        } else {
            print("receivedCollection: is nil")
        }
    }
    
    // Card deletion
    func deleteCardShown() {
        // should only be one card shown at a time. If not function will select first regardless.
        guard let cardToDelete = mcCollection.visibleCells.first as? MCCollectionViewCell else {
            return
        }
        
        guard let id = cardToDelete.organismCard?.id else {
            return
        }

        guard let index = mcCollection.indexPathsForVisibleItems.first else {
            return
        }
        
        // TODO: create an alert with common name and species prior to deletion
        
        let isSuccess = coreData.deleteOrganism(id: id)
        // TODO: add alert indicating deletion
        print("card deletion: \(isSuccess)")
        

        myCollection?.remove(at: index.row)
        // mcCollection.deleteItems(at: [index])
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionAddCard" {
            let navVC = segue.destination as! UINavigationController
            // TODO: determine the next vc
            let vc = navVC.topViewController as! SearchController
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
    
    // MARK: Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCCollectionViewCell", for: indexPath) as! MCCollectionViewCell
        
        guard let card = myCollection?[indexPath.row] else {
            return cell
        }
        cell.organismCard = card
        cell.cellTableView.dataSource = cell.self
        cell.cellTableView.delegate = cell.self
        cell.cellTableView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0)
        cell.cellTableView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0)
        cell.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0)
        cell.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: mcCollection.bounds.width,)
//    }
    
    /* the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values. */
    
}
