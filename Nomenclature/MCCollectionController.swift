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
    
    var numberOfPages: Int = 0
    
    // IBOutlets
    @IBOutlet weak var mcCollection: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        setMyCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureCollection()
        testReceivedCollection()
        
    }
    
    // IBActions
    @IBAction func addCardButton(_ sender: Any) {
        addCard()
    }
    
    @IBAction func deleteCardButton(_ sender: Any) {
        deletionAlert()
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        guard let nextIndex = getIndex(offset: 1) else {
            return
        }
        
        mcCollection.scrollToItem(at: nextIndex as IndexPath, at: .right, animated: true)
    }
    
    @IBAction func backwardButton(_ sender: Any) {
        guard let nextIndex = getIndex(offset: -1) else {
            return
        }
        
        mcCollection.scrollToItem(at: nextIndex as IndexPath, at: .right, animated: true)
    }
    
    func getIndex(offset: Int) -> IndexPath? {
        guard let currentIndex = mcCollection.indexPathsForVisibleItems.first else {
            return nil
        }
        
        let nextIndex = NSIndexPath(item: currentIndex.row + offset, section: 0) as IndexPath
        if offset > 0 && nextIndex.row < numberOfPages {
            print("index = + \(nextIndex.row)")
            return nextIndex
        } else if offset < 0 && nextIndex.row >= 0 {
            print("index = - \(nextIndex.row)")
            return nextIndex
        } else {
            print("no index returned")
            return nil
        }
        
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
    // Deletion alert
    func deletionAlert() {
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertActionDelete = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alertAction) in
            self.deleteCardShown()
        })
        
        let alert = UIAlertController(title: "Delete", message: "Delete selected collections?", preferredStyle: .actionSheet)
        alert.addAction(alertActionCancel)
        alert.addAction(alertActionDelete)
        present(alert, animated: true, completion: nil)
    }
    
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
        
        let isSuccess = coreData.deleteOrganism(id: id)
        // TODO: add alert indicating deletion
        print("card deletion: \(isSuccess)")
        

        myCollection?.remove(at: index.row)
        // mcCollection.deleteItems(at: [index])
    }
    
    // Navigation
    func addCard() {
        performSegue(withIdentifier: "collectionAddCard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionAddCard" {
            let navVC = segue.destination as! UINavigationController
            // TODO: determine the next vc
            let vc = navVC.topViewController as! SearchController
            vc.receivedCollection = receivedCollection
        }
    }
    
    // Check for items
    func noItemsAlert() {
        let msg = "Nothing to see here! Why don't you go search for something."
        let alert = UIAlertController(title: "No Saved Items", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
            (action) in
            DispatchQueue.main.async {
                self.addCard()
            }
        })
        alert.addAction(alertAction)
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Collection view methods
    func ConfigureCollection() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        // TODO: quick fix, find a better solution
        let cellHeight = mcCollection.bounds.height
        
        layout.itemSize = CGSize(width: view.bounds.width, height: cellHeight)
        
        mcCollection.collectionViewLayout = layout
        mcCollection.delegate = self
        mcCollection.dataSource = self
        mcCollection.isPagingEnabled = true
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = myCollection?.count ?? 0
        numberOfPages = count
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCCollectionViewCell", for: indexPath) as! MCCollectionViewCell
        
        guard let card = myCollection?[indexPath.row] else {
            noItemsAlert()
            return cell
        }
        
        cell.organismCard = card
        cell.cellTableView.dataSource = cell.self
        cell.cellTableView.delegate = cell.self
        cell.cellTableView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0)
        cell.cellTableView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0)
        cell.cellTableView.sectionHeaderHeight = 0
        cell.cellTableView.sectionFooterHeight = 0
        cell.cellTableView.sectionIndexBackgroundColor = UIColor.white
        cell.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0)
        cell.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0)
        
        return cell
    }
    
}
