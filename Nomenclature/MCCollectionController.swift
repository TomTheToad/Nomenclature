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
    
    @IBOutlet weak var mcCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcCollection.delegate = self
        mcCollection.dataSource = self
        
    }
    
    // MARK: Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mcCollection.dequeueReusableCell(withReuseIdentifier: "MCCollectionCell", for: indexPath) as! MCCollctionCell
        guard let vernacularName = myCollection?[indexPath.row].vernacular else {
            cell.MCCollectionLabel.text = "Name Missing"
            return cell
        }
        cell.MCCollectionLabel.text = vernacularName
        return cell
    }
    
}
