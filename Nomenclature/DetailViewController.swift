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
    private let flikr = FlickrAPIController()
    var recievedOrganismCard: OrganismCard?
    var organismCard: OrganismCard {
        get {
            guard let card = recievedOrganismCard else {
                // handle error, this should never happen
                fatalError("Application error: missing data")
            }
            return card
        }
    }
    
    var searchString: String {
        guard let searchString = recievedOrganismCard?.fetchFirstCommonName(language: "english") else {
            return "missing data"
        }
        return searchString.0
    }
    
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
        if let image = organismCard.photo?.image {
            organismImage.image = image
        } else {
            organismImage.image = UIImage(named: "addImage")!
        }
        
    }
    
    func setImage(photo: Photo) {
        guard let url = photo.urlForImage() else {
            print("unable to download image")
            return
        }
        
        var thisPhoto = photo
        organismCard.photo = photo
        
        flikr.downloadImageFromFlikrURL(url: url, completionHandler: {
            (data, response, error) in
            if error == nil {
                guard let imageData = data else {
                    return
                }
                thisPhoto.imageData = imageData as NSData
                DispatchQueue.main.async {
                    self.receivedPhoto = thisPhoto
                    self.organismImage.image = UIImage(data: imageData)
                }
            } else {
                print("flikr download image error has occured. response: \(response.debugDescription)")
                return
            }
        })
    }
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organismCard.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as? DetailViewCell else {
            fatalError("table cell error")
        }
        
        let content = organismCard.dataSource[indexPath.row]
        
        cell.headingLabel.text = content.cellHeading
        cell.nameLabel.text = content.cellContent
        return cell
    }
    
    func fetchFlikrImages() {
        let flikr = FlickrAPIController()

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
        let isSuccess = coreData.createOrganism(organismCard: organismCard)
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
