//
//  DetailViewController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/12/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Fields
    let coreData = CoreDataController()
    var organismData = NSDictionary()
    let headings = ["vernacular", "kingdom", "phylum", "class", "order", "suborder", "family", "genus", "species"]
    var receivedPhoto: Photo?
    
    // IBActions
    @IBAction func saveAction(_ sender: Any) {
        saveOrganism()
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        fetchFlikrImages()
    }
    
    // IBOutlets
    @IBOutlet weak var organismImage: UIImageView!
    @IBAction func myCollectionButton(_ sender: Any) {
        returnToInitialVC()
    }

    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setImage()
    }
    
    func setImage() {
        if let image = organismData.value(forKey: "photo") as? Data {
            guard let uiImage = UIImage(data: image) else {
                return
            }
            
            organismImage.image = uiImage
            
        } else {
            organismImage.image = UIImage(named: "addImage")
        }
    }

    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as? DetailViewCell else {
            fatalError("table cell error")
        }
        
        let heading = headings[indexPath.row]
        let name = organismData.value(forKey: heading) ?? "missing data"
        
        cell.headingLabel.text = heading
        cell.nameLabel.text = String(describing: name)
        
        return cell
    }
    
    func fetchFlikrImages() {
        let flikr = FlickrAPIController()
        guard let searchString = organismData.value(forKey: "vernacular") as? String else {
            print("nothing to search")
            return
        }
        
        do {
            
            try flikr.getImageArray(textToSearch: searchString, completionHander: {
                (error, data) in
                if error == nil {
                    guard let dict = data else {
                        return
                    }
                    
                    // TODO: check for single photo return
                    let photos = flikr.convertNSDictArraytoPhotoArray(dictionaryArray: dict)
                    
                    DispatchQueue.main.async {
                        self.presentImageSearch(searchString: searchString, photos: photos)
                    }
                    
                } else {
                    return
                }
                
            })
        } catch {
            return
        }
    }
    
    // CoreData methods
    // TODO: alter for edit
    func saveOrganism() {
        let isSuccess = coreData.addOrganism(dict: organismData)
        if isSuccess {
            print("Organism saved")
        } else {
            print("Save failed")
        }
    }
    
    // Navigation methods
    func returnToInitialVC() {
        guard let initialVC = storyboard?.instantiateInitialViewController() else {
            // big error goes here
            print("Could not instantiate initial view controller!")
            return
        }
        
        present(initialVC, animated: false, completion: nil)
    }
    
    func presentImageSearch(searchString: String, photos: [Photo]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSearchController") as! ImageSearchController
        vc.receivedPhotos = photos
        vc.searchString = searchString
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
}
