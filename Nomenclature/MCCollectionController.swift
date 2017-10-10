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
        
        return cell
    }
//
////        cell.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0)
////        cell.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: 0)
////        cell.topAnchor.constraint(lessThanOrEqualTo: collectionView.topAnchor)
////        cell.bottomAnchor.constraint(lessThanOrEqualTo: collectionView.bottomAnchor)
////        
////        cell.cardStackView.leftAnchor.constraint(equalTo: cell.leftAnchor)
////        cell.cardStackView.rightAnchor.constraint(equalTo: cell.rightAnchor)
//        
//        guard let card = myCollection?[indexPath.row] else {
//            return cell
//        }
//        
//        if let id = card.id {
//            cell.id = id
//        }
//        
//        if let kingdom = card.kingdom {
//            cell.kingdomTextField.text = kingdom
//        }
//        
//        if let phylum = card.phylum {
//            cell.phylumTextField.text = phylum
//        }
//        
//        if let sciClass = card.sciClass {
//            cell.classTextField.text = sciClass
//        }
//        
//        if let order = card.order {
//            cell.orderTextField.text = order
//        }
//        
//        if let family = card.family {
//            cell.familyTextField.text = family
//        }
//        
//        if let genus = card.genus {
//            cell.genusTextField.text = genus
//        }
//        
//        if let species = card.species {
//            cell.speciesTextField.text = species
//        }
//        
//        if let commonName = card.fetchFirstCommonName(language: "english") {
//            // use type
//            cell.vernacularTextField.text = commonName.name
//        } else {
//            cell.vernacularTextField.text = "missing data"
//        }
//        
//        guard let photo = card.photo else {
//            print("collection photo not found")
//            cell.organismImage.image = UIImage(named: "addImage")
//            return cell
//        }
//        
//        if let image = photo.image {
//                print("image found")
//                cell.organismImage.image = image
//        } else {
//            print("image not found")
//            cell.organismImage.image = UIImage(named: "addImage")
//        }
//        
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.height - collectionView.contentInset.bottom - collectionView.contentInset.top)
    }
    
}
