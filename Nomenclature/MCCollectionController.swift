//
//  MCCollectionController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/24/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Dependencies
    let coreData = CoreDataController()
    
    // Fields
    var receivedCollection: Collection?
    var organismCardFactory = OrganismCardFactory()

    var myCollection: [OrganismCard]? {
        didSet {
            mcCollection.reloadData()
        }
    }
    
    // Used to set offset for paging within collection
    var numberOfPages: Int = 0
    
    // IBOutlets
    @IBOutlet weak var mcCollection: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
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
    
    // View triggered events
    override func viewWillAppear(_ animated: Bool) {
        setMyCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
    }
    
    // Helper for forward and back paging buttons
    func getIndex(offset: Int) -> IndexPath? {
        guard let currentIndex = mcCollection.indexPathsForVisibleItems.first else {
            return nil
        }
        
        let nextIndex = NSIndexPath(item: currentIndex.row + offset, section: 0) as IndexPath
        if offset > 0 && nextIndex.row < numberOfPages {
            return nextIndex
        } else if offset < 0 && nextIndex.row >= 0 {
            return nextIndex
        } else {
            return nil
        }
        
    }
    
    // Card deletion
    // Deletion alert: make sure the user mean't to delete the item shown
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
        
        guard let id = cardToDelete.receivedCard?.id else {
            return
        }

        guard let index = mcCollection.indexPathsForVisibleItems.first else {
            return
        }
        
        let isSuccess = coreData.deleteOrganism(id: id)
        
        let alertGen = OKAlertGenerator(alertMessage: "Oops, Unable to Delete Item. Please try again")
        if isSuccess {
            alertGen.message = "Item deleted"
            alertGen.title = "Success"
        }
        present(alertGen.getAlertToPresent(), animated: true, completion: nil)
        
        myCollection?.remove(at: index.row)
    }
    
    // Check any items in collection. If none, trigger segue to search after alert.
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
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Collection view methods
    func configureCollection() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero

        mcCollection.collectionViewLayout = layout
        mcCollection.delegate = self
        mcCollection.dataSource = self
        mcCollection.isPagingEnabled = true
        mcCollection.allowsSelection = false
    }
    
    func setMyCollection() {
        guard let thisCollection = receivedCollection else {
            print("collection missing")
            return
        }
        
        guard let organisms = coreData.fetchAllOrganismsInCollection(collection: thisCollection) else {
            return
        }
        
        if organisms.isEmpty {
            noItemsAlert()
        }
        
        myCollection = organismCardFactory.createCardArray(organismArray: organisms)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = myCollection?.count ?? 0
        numberOfPages = count

        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mcCollection.bounds.width, height: mcCollection.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCCollectionViewCell", for: indexPath) as! MCCollectionViewCell
        
        guard let card = myCollection?[indexPath.row] else {
            print("ERROR: missing card")
            return cell
        }
        
        // Organism card
        cell.receivedCard = card

        // Cell table configuration
        cell.cellTableView.dataSource = cell.self
        cell.cellTableView.delegate = cell.self
        cell.cellTableView.allowsSelection = false
        cell.cellTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.cellTableView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0)
        cell.cellTableView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0)
        cell.cellTableView.sectionIndexBackgroundColor = UIColor.white
        cell.cellTableView.rowHeight = UITableViewAutomaticDimension
        cell.cellTableView.contentInset = UIEdgeInsets.zero
        
        cell.cellTableView.reloadData()
        
        return cell
    }
    
    // MARK: Navigation
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
    
}
