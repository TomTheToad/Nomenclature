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
//    let defaultImage = UIImage(named: "defaultImage")!
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
        
        configureCollection()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "collectionsToCreateCollection", sender: self)
    }
    
    // CollectionView methods
    func configureCollection() {

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        let itemSize = myCollectionGroupsView.bounds.width / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        myCollectionGroupsView.collectionViewLayout = layout
        myCollectionGroupsView.delegate = self
        myCollectionGroupsView.dataSource = self
        
    }
    
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
                 cell.collectionImageView.image = #imageLiteral(resourceName: "defaultImage")
                return cell
            }
            
            let image = UIImage(data: imageData as Data)
            cell.collectionImageView.image = image
            return cell
        }
        // TODO: Return default image
        cell.collectionImageView.image = #imageLiteral(resourceName: "defaultImage")
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
