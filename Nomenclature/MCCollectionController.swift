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
    var myCollection: [Organism]? = {
        let coreData = CoreDataController()
        guard let results = coreData.fetchAll() else {
            print("no results")
            return nil
        }
        return results
    }()
    
    // IBOutlets
    @IBOutlet weak var mcCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcCollection.delegate = self
        mcCollection.dataSource = self
        mcCollection.isPagingEnabled = true
        
    }
    
    // IBActions
    @IBAction func addCardButton(_ sender: Any) {
        performSegue(withIdentifier: "collectionAddCard", sender: self)
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
            cell.vernacularTextField.text = vernacular
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
