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
    private let coreData = CoreDataController()
    
    var organismData = NSDictionary()
    private var searchString = String()
    
    private let headings = ["vernacular", "kingdom", "phylum", "class", "order", "suborder", "family", "genus", "species"]
    
    var flikrPhotos: [Photo]? {
        didSet {
            performSegue(withIdentifier: "imageSearchSegue", sender: self)
        }
    }
    
    var receivedPhoto: Photo?
    
    // IBActions
    @IBAction func saveAction(_ sender: Any) {
        saveOrganism()
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        fetchFlikrImages()
    }
    
    @IBAction func saveToDetailViewController(_: UIStoryboardSegue) {
        
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
    
    func setImage(photo: Photo) {
        guard let image = photo.image else {
            print("image missing")
            return
        }
        
        organismImage.image = image
        receivedPhoto = photo
        
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
        
        self.searchString = searchString
        
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
                        self.flikrPhotos = photos
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
        let isSuccess = coreData.addOrganism(dict: organismData, photo: receivedPhoto)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSearchSegue" {
            let vc = segue.destination as! ImageSearchController
            vc.receivedPhotos = flikrPhotos
            vc.searchString = searchString
        }
    }
    
}
