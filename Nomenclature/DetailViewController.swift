//
//  DetailViewController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/12/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// A class representing the assembled detail of an organism prior to saving.
// This class allows for the addition of an image using the Flickr api.
// TODO: attempted refactor of class title. Multiple errors produced. Figure out best way to refactor.

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /* Fields */
    // Dependencies
    private let coreData = CoreDataController()
    private let flickr = FlickrAPIController()
    
    // Organism card passed from previous controllers.
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
    
    // Determine the initial search for Flickr based on the first english vernacular name.
    // TODO: Will need to eventually make this check for default language.
    var searchString: String {
        guard let searchString = recievedOrganismCard?.fetchFirstCommonName(language: "english") else {
            return "missing data"
        }
        return searchString.name
    }
    
    // Fetched Flickr data will trigger segue to display thumbnails for choice.
    var flickrPhotos: [Photo]? {
        didSet {
            performSegue(withIdentifier: "imageSearchSegue", sender: self)
        }
    }
    
    // Photo struct received from Flickr search and choice.
    var receivedPhoto: Photo?
    
    /* Interface Builder related methods */
    // Save button action
    @IBAction func saveAction(_ sender: Any) {
        if checkForImage() {
            saveOrganism()
        } else {
            noImageAlertContinue()
        }
    }
    
    // Add image button triggering Flickr search and segue.
    @IBAction func addImageButton(_ sender: Any) {
        addImage()
    }
    
    @IBAction func saveToDetailViewController(_: UIStoryboardSegue) {
        
    }

    @IBAction func cancelButton(_ sender: Any) {
        dismissNavigationController()
    }

    // IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var organismImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // View did load prep
    override func viewDidLoad() {
        
        activityIndicator.stopAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        setImage()
    }
    
    /* Image and photo related methods */
    // Check for and set image to card>>photo and organism image.
    func setImage() {
        if let image = organismCard.photo?.image {
            organismImage.image = image
        } else {
            organismImage.image = UIImage(named: "addImage")!
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.addImageButton(_:)))
            organismImage.isUserInteractionEnabled = true
            organismImage.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    // Fetch images from Flickr
    func addImage() {
        activityIndicator.startAnimating()
        fetchFlickrImages()
    }
    
    // Fetch full resolution image from Flickr after chosen from ImageSearch thumbnails.
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
    
    // Prefetch Flickr data for ImageSearchController
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
    
    // Helper to determine if user chosen image is present.
    func checkForImage() -> Bool {
        if receivedPhoto?.imageData == nil {
            return false
        } else {
            return true
        }
    }
    
    /* MARK: TableView methods */
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
    

    /* Core Data related methods */
    func saveOrganism() {
        let isSuccess = coreData.createOrganism(organismCard: organismCard)
        if isSuccess {
            let alertAction1 = UIAlertAction(title: "OK", style: .default, handler: {
                (UIAlertAction) in
                self.dismissNavigationController()
            })
            let alert = UIAlertController(title: "Success", message: "Organism saved.", preferredStyle: .actionSheet)
            alert.addAction(alertAction1)
            present(alert, animated: true, completion: nil)
            
        } else {
            let alertAction1 = UIAlertAction(title: "OK", style: .default, handler: {
                (UIAlertAction) in
                self.dismissNavigationController()
            })
            let alert = UIAlertController(title: "Save Failed", message: "Oops, looks like we encoutered an error. Please try again.", preferredStyle: .actionSheet)
            alert.addAction(alertAction1)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /* MARK: Navigation Methods */
    // Dismiss current navigation stack
    func dismissNavigationController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /* MARK: User Alert Methods */
    // Alert the user to missing image. Prompt to add image or continue without.
    func noImageAlertContinue() {
        let alertActionYes = UIAlertAction(title: "Add image", style: .default, handler: {
            (UIAlertAction) in
            self.addImage()
        })
        let alertActionNo = UIAlertAction(title: "No Image", style: .default, handler: {
            (UIAlertAction) in
            self.saveOrganism()
        })
        let alert = UIAlertController(title: "No image selected", message: "Do you want to add an image before saving?", preferredStyle: .actionSheet)
        alert.addAction(alertActionNo)
        alert.addAction(alertActionYes)
        present(alert, animated: true, completion: nil)
    }
    
    // Generic OK alerts.
    func GenericAlert(message: String? = nil) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let thisMessage = message ?? "Oops, your reguest failed. Please check your connection and try again."
            let alert = OKAlertGenerator(alertMessage: thisMessage)
            self.present(alert.getAlertToPresent(), animated: false, completion: nil)
        }
    }
}
