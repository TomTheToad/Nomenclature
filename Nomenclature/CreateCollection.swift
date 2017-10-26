//
//  CreateCollection.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/23/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class CreateCollection: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        configureKeyboard()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    // Collection methods
    func createCollection() {
        
        if (titleTextField.text?.isEmpty)! {
            sendAlert(msg: "Title field is empty.")
            return
        }
        
        if (descriptionTextView.text?.isEmpty)! {
            sendAlert(msg: "Description is empty.")
        }
        
        guard let thisTitle = titleTextField.text else {
            sendAlert(msg: "Title field is empty.")
            return
        }
        
        guard let thisDescription = descriptionTextView.text else {
            sendAlert(msg: "Description is empty.")
            return
        }
        
       collection = coreData.createCollection(title: thisTitle, description: thisDescription)
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
    
    // Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func configureKeyboard() {
        descriptionTextView.addDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && descriptionTextView.isFocused {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 && descriptionTextView.isFocused == false {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension UITextView {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
