//
//  MCGCollectionController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/19/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Controller responsible for displaying and deleting groups of organism collections.

/*
 TODO: add blank cards
 TODO: editable fields
 TODO: notes section
 TODO: webView - wikipedia scrape?
*/

import UIKit

class MCGCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Dependencies
    let coreData = CoreDataController()

    // Fields
    var myCollectionGroups: [Collection]? {
        didSet {
            myCollectionGroupsView.reloadData()
        }
    }
    
    var selectedCollection: Collection? {
        didSet {
            presentMyCollection()
        }
    }
    
    // IBoutlets
    @IBOutlet weak var myCollectionGroupsView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    // IBActions
    @IBAction func addButtonAction(_ sender: Any) {
        createCollection()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        setEditing(!isEditing, animated: false)
    }
    
    // View triggered events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMyCollectionGroups()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
    }
    
    // Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        myCollectionGroupsView.allowsMultipleSelection = !myCollectionGroupsView.allowsMultipleSelection

        setEditButton()
        setDeleteButton()

    }
    
    // Helpers
    func setEditButton() {
        if isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    func setDeleteButton() {
        deleteButton.isHidden = !deleteButton.isHidden
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        deletionAlert()
    }
    
    // Deselect all
    func deselectAll() {
        guard let selectedItems = myCollectionGroupsView.indexPathsForSelectedItems else {
            return
        }
        
        for thisIndex in selectedItems {
            myCollectionGroupsView.deselectItem(at: thisIndex, animated: true)
        }
    }
    
    func checkForEmptyCollection() {
        if myCollectionGroupsView.numberOfItems(inSection: 0) == 0 {
            noCollectionsAlert()
        }
    }

    // MARK: Collection methods
    func setMyCollectionGroups() {
        guard let collections = coreData.fetchAllCollections() else {
            noCollectionsAlert()
            return
        }
        if collections.isEmpty {
            noCollectionsAlert()
        }
        myCollectionGroups = collections
    }
    
    func deleteSelectedCollections() {
        if isEditing == true {
            guard let indexArray = myCollectionGroupsView.indexPathsForSelectedItems else {
                return
            }
            
            for item in indexArray {
                guard let thisCollection = myCollectionGroups?[item.row] else {
                    return
                }
                
                let results = coreData.deleteCollection(collection: thisCollection)
                if results {
                    myCollectionGroups?.remove(at: item.row)
                }
                
                myCollectionGroups = coreData.fetchAllCollections()
            }
        }
        // TODO: remove, insert, etc.
        myCollectionGroupsView.reloadData()
        setEditing(false, animated: false)
    }
    
    func configureCollection() {

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        let itemSize = UIScreen.main.bounds.width / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        myCollectionGroupsView.collectionViewLayout = layout
        myCollectionGroupsView.delegate = self
        myCollectionGroupsView.dataSource = self
        myCollectionGroupsView.allowsMultipleSelection = false
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        
        guard let count = myCollectionGroups?.count else {
            return 0
        }
        
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCGCollectionViewCell", for: indexPath) as! MCGCollectionViewCell
        
        if indexPath.section == 1 {
            cell.collectionImageView.image = #imageLiteral(resourceName: "add")
            cell.titleLabel.isHidden = true
            return cell
        }
        
        cell.backgroundColor = UIColor.darkGray
        
        guard let thisCollection = myCollectionGroups?[indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.isHidden = false
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
        cell.collectionImageView.image = #imageLiteral(resourceName: "defaultImage")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing == false {
            if indexPath.section == 1 {
                deselectAll()
                createCollection()
            } else {
                guard let thisCollection = myCollectionGroups?[indexPath.row] else {
                    // TODO: internal error
                    print("collection missing!")
                    return
                }
                
                selectedCollection = thisCollection
                deselectAll()
            }
        } else {
            deleteButton.isEnabled = true
        }
        
    }
    
    // MARK: Navigation Methods
    func createCollection() {
        performSegue(withIdentifier: "collectionsToCreateCollection", sender: self)
    }
    
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
    
    // Unwind segue
    @IBAction func unwindToCollections(segue:UIStoryboardSegue) { }
    
    // Alerts
    func deletionAlert() {
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertActionDelete = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alertAction) in
            self.deleteSelectedCollections()
        })
        
        let alert = UIAlertController(title: "Delete", message: "Delete selected collections?", preferredStyle: .actionSheet)
        alert.addAction(alertActionCancel)
        alert.addAction(alertActionDelete)
        present(alert, animated: true, completion: nil)
    }
    
    func noCollectionsAlert() {
        let okAlert = OKAlertGenerator(alertMessage: "Hmm it appears that you don't have anything here. Tap the plus icon to create a new collection")
        okAlert.title = "Oops"
        present(okAlert.getAlertToPresent(), animated: true, completion: nil)
    }
    
}
