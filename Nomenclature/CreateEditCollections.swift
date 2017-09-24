//
//  CreateEditCollections.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/23/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class CreateEditCollections: UIViewController {
    
    // Fields
    let coreData = CoreDataController()
    var collection: Collection? {
        didSet {
            presentMyCollection()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // IBActions
    @IBAction func saveButtonAction(_ sender: Any) {
        createCollection()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    // Collection methods
    func createCollection() {
        
        guard let thisTitle = titleTextField.text else {
            // TODO: present alert
            print("collection title missing")
            return
        }
        
        guard let thisDescription = descriptionTextView.text else {
            // TODO: present alert or allow for empty description?
            print("collection description missing")
            return
        }
        
       collection = coreData.createCollection(title: thisTitle, description: thisDescription)
    }
    
    // Navigation
    func presentMyCollection() {
        performSegue(withIdentifier: "createCollectionsToCollection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createCollectionsToCollection" {
            let tabBarVC = segue.destination as! UITabBarController
            let vc = tabBarVC.viewControllers?.first as! MCCollectionController
            vc.receivedCollection = collection
        }
    }
}
