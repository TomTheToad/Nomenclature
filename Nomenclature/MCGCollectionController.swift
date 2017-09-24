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
    
    // IBoutlets
    @IBOutlet weak var myCollectionGroupsView: UICollectionView!
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "collectionsToCreateCollection", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionGroupsView.delegate = self
        myCollectionGroupsView.dataSource = self
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
        
        return cell
    }
    
}
