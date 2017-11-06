//
//  CreateCollection.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/23/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Class responsible for simple collection creation

import UIKit

class CreateCollection: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // Dependencies
    let coreData = CoreDataController()
    
    // Fields
    var collection: Collection? {
        didSet {
            presentMyCollection()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    
    // IBActions
    @IBAction func saveButtonAction(_ sender: Any) {
        createCollection()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
    }
    
    // Collection methods
    func createCollection() {
        
        if (titleTextField.text?.isEmpty)! {
            sendAlert(msg: "Title field is empty.")
            return
        }
        
        guard let thisTitle = titleTextField.text else {
            sendAlert(msg: "Title field is empty.")
            return
        }
        
       collection = coreData.createCollection(title: thisTitle)
    }
    
    // Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createCollection()
        return true
    }
    
    // Alert
    func sendAlert(msg: String) {
        let alertGen = OKAlertGenerator(alertMessage: msg)
        present(alertGen.getAlertToPresent(), animated: true, completion: nil)
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
