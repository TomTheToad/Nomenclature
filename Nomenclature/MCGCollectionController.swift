//
//  MCGCollectionController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/19/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCGCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Fields
    let coreData = CoreDataController()
    var myCollectionGroups: [Collection]? = {
       let coreData = CoreDataController()
        return coreData.fetchAllCollections()
    }()
    var selectedCollection: Collection? {
        didSet {
            presentMyCollection()
        }
    }
    
    // IBoutlets
    @IBOutlet weak var myCollectionGroupsView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionGroupsView.delegate = self
        myCollectionGroupsView.dataSource = self
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "collectionsToCreateCollection", sender: self)
    }
    
    // CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = myCollectionGroups?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCGCollectionViewCell", for: indexPath) as! MCGCollectionViewCell
        cell.backgroundColor = UIColor.darkGray
        
        guard let thisCollection = myCollectionGroups?[indexPath.row] else {
            return cell
        }
        cell.titleLabel.text = thisCollection.title
        
        if let thisOrganism = thisCollection.hasOrganism?.allObjects.first as? Organism {
            guard let imageData = thisOrganism.thumbnailImage else {
                // TODO: create default image
                // cell.collectionImageView.image = someDefaultImage
                return cell
            }
            
            let image = UIImage(data: imageData as Data)
            cell.collectionImageView.image = image
            return cell
        }
        // TODO: Return default image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let thisCollection = myCollectionGroups?[indexPath.row] else {
            // TODO: internal error
            print("collection missing!")
            return
        }
        
        selectedCollection = thisCollection
        
    }
    
    // Navigation
    func presentMyCollection() {
        performSegue(withIdentifier: "collectionsToSingleCollection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionsToSingleCollection" {
            let tabVC = segue.destination as! UITabBarController
            let vc1 = tabVC.viewControllers?.first as! MCCollectionController
            let vc2 = tabVC.viewControllers?.last as! MCTableController
            vc1.receivedCollection = selectedCollection
            vc2.receivedCollection = selectedCollection
        }
    }
    
}
