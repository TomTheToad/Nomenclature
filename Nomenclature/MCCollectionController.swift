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

    var myCollection: [Organism]? {
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
    
    // Test methods
    func testReceivedCollection() {
        if receivedCollection != nil {
            print("receivedCollection: not nil")
        } else {
            print("receivedCollection: is nil")
        }
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
        
        myCollection = coreData.fetchAllOrganismsInCollection(collection: thisCollection)
    }
    
    // MARK: Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCCollectionViewCell", for: indexPath) as! MCCollectionViewCell
        
        guard let organism = myCollection?[indexPath.row] else {
            return cell
        }
        
        if let vernacular = organism.vernacular {
            // TODO: create struct for this
            if let names = vernacular as? [(name: String, language: String)] {
            
                var text = ""
                for name in names {
                    text = "\(name.language): \(name.name) "
                }
                cell.vernacularTextField.text = text
            } else {
                cell.vernacularTextField.text = "missing"
            }
        }
        
        if let kingdom = organism.kingdom {
            cell.kingdomTextField.text = kingdom
        }
        
        if let phylum = organism.phylum {
            cell.phylumTextField.text = phylum
        }
        
        if let sciClass = organism.sciClass {
            cell.classTextField.text = sciClass
        }
        
        if let order = organism.order {
            cell.orderTextField.text = order
        }
        
        if let family = organism.family {
            cell.familyTextField.text = family
        }
        
        if let genus = organism.genus {
            cell.genusTextField.text = genus
        }
        
        if let species = organism.species {
            cell.speciesTextField.text = species
        }
        
        if let imageData = organism.image {
            guard let image = UIImage(data: imageData as Data) else {
                print("default image called")
                cell.organismImage.image = UIImage(named: "addImage")
                return cell
            }
            cell.organismImage.image = image
        } else {
            cell.organismImage.image = UIImage(named: "addImage")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.height - collectionView.contentInset.bottom - collectionView.contentInset.top)
    }
    
}
