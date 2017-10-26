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
    private let flickr = FlickrAPIController()
    var recievedOrganismCard: OrganismCard?
    var organismCard: OrganismCard {
        get {
            guard let card = recievedOrganismCard else {
                // handle error, this should never happen but probably will
                fatalError("Application error: missing data")
            }
            return card
        }
    }
    
    var searchString: String {
        guard let searchString = recievedOrganismCard?.fetchFirstCommonName(language: "english") else {
            return "missing data"
        }
        return searchString.name
    }
    
    var flickrPhotos: [Photo]? {
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
        activityIndicator.stopAnimating()
        fetchFlickrImages()
    }
    
    @IBAction func saveToDetailViewController(_: UIStoryboardSegue) {
        
    }
    
    // IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var organismImage: UIImageView!
    @IBAction func cancelButton(_ sender: Any) {
        returnToInitialVC()
    }

    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        activityIndicator.stopAnimating()
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
        guard let url = photo.imageURL else {
            return
        }
        
        var thisPhoto = photo
        
        flickr.downloadImageFromFlickrURL(url: url, completionHandler: {
            (data, response, error) in
            if error == nil {
                guard let imageData = data else {
                    return
                }
                thisPhoto.imageData = imageData as NSData
                self.organismCard.photo = thisPhoto
                DispatchQueue.main.async {
                    self.receivedPhoto = thisPhoto
                    // TODO: remove redundancy
                    self.organismImage.image = UIImage(data: imageData)
                }
            } else {
                self.GenericAlert()
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
    
    func fetchFlickrImages() {
        do {
            
            try flickr.getImageArray(textToSearch: searchString, completionHander: {
                (error, data) in
                if error == nil {
                    guard let dict = data else {
                        return
                    }
                    
                    let photos = self.flickr.convertNSDictArraytoPhotoArray(dictionaryArray: dict)
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.flickrPhotos = photos
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
    func saveOrganism() {
        let isSuccess = coreData.createOrganism(organismCard: organismCard)
        if isSuccess {
            let alertAction1 = UIAlertAction(title: "OK", style: .default, handler: {
                (UIAlertAction) in
                self.returnToInitialVC()
            })
            let alert = UIAlertController(title: "Success", message: "Organism saved.", preferredStyle: .actionSheet)
            alert.addAction(alertAction1)
            present(alert, animated: true, completion: nil)
            
        } else {
            let alertAction1 = UIAlertAction(title: "OK", style: .default, handler: {
                (UIAlertAction) in
                self.returnToInitialVC()
            })
            let alert = UIAlertController(title: "Save Failed", message: "Oops, looks like we encoutered an error. Please try again.", preferredStyle: .actionSheet)
            alert.addAction(alertAction1)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Navigation methods
    func returnToInitialVC() {
        guard let initialVC = storyboard?.instantiateInitialViewController() else {
            // big error goes here
            print("Could not instantiate initial view controller!")
            return
        }
        
        present(initialVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSearchSegue" {
            let vc = segue.destination as! ImageSearchController
            vc.receivedPhotos = flickrPhotos
            vc.searchString = searchString
        }
    }
    
    func GenericAlert(message: String? = nil) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let thisMessage = message ?? "Oops, your reguest failed. Please check your connection and try again."
            let alert = OKAlertGenerator(alertMessage: thisMessage)
            self.present(alert.getAlertToPresent(), animated: false, completion: nil)
        }
    }
}
