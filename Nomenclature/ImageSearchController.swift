//
//  ImageSearchController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/13/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class ImageSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Dependencies
    let flickr = FlickrAPIController()
    var searchString = String()
    
    // Fields
    var receivedPhotos: [Photo]?
    var selectedPhoto: Photo?
    
    // IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        searchTextField.text = searchString
        
    }
    
    // IBActions
    @IBAction func searchAgainButton(_sender: Any) {
        activityIndicator.startAnimating()
        fetchFlickrImages()
        view.endEditing(true)
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        performSegue(withIdentifier: "saveToDetailVC", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // Flickr methods
    // Only calls when reload is requested.
    func fetchFlickrImages() {
        guard let newSearchString = searchTextField.text else {
            return
        }
        
        do {
            
            try flickr.getImageArray(textToSearch: newSearchString, completionHander: {
                (error, data) in
                if error == nil {
                    guard let dict = data else {
                        return
                    }
                    
                    let photos = self.flickr.convertNSDictArraytoPhotoArray(dictionaryArray: dict)
                    
                    DispatchQueue.main.async {
                        self.receivedPhotos = photos
                        self.imageCollectionView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    
                } else {
                    return
                }
                
            })
        } catch {
            return
        }
        
    }
    
    /* Collection View Methods */
    func configureCollection() {
        let size = UIScreen.main.bounds.width / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.itemSize = CGSize(width: size, height: size)
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.allowsSelection = true
        imageCollectionView.allowsMultipleSelection = false
        imageCollectionView.contentInset = .zero
        imageCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = receivedPhotos?.count else {
            GenericAlert(message: "Auto search did not return anything for the given common name. Try entering a custom search term above and search again.")
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.red
        
        guard var photo = receivedPhotos?[indexPath.row] else {
            return cell
        }
        
        // TODO: this may never be called. Test without
        if let imageData = photo.imageData {
            cell.backgroundColor = UIColor.blue
            cell.imageView.image = UIImage(data: imageData as Data)
            cell.photo = photo
        } else if let thumbURL = photo.thumbImageURL {
            flickr.downloadImageFromFlickrURL(url: thumbURL, completionHandler: {
                (data, response, error) in
                if error == nil {
                    guard let imageData = data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        cell.backgroundColor = UIColor.blue
                        cell.imageView.image = UIImage(data: imageData)
                        photo.thumbImageData = imageData as NSData
                        cell.photo = photo
                    }
                    
                } else {
                    return
                }
                
            })
        } else {
            print("ERROR: cell")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            // TODO: send error
            return
        }
        
        guard let photo = cell.photo else {
            // TODO: send error
            return
        }
        
        cell.isSelected = true
        selectedPhoto = photo
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            // TODO: send error
            return
        }
        
        cell.isSelected = false
    }

    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveToDetailVC" {
            let vc = segue.destination as! DetailViewController
            
            guard let photo = selectedPhoto else {
                return
            }
            
            vc.receivedPhoto = photo
            vc.setImage(photo: photo)
        }
    }
    
    // User Alert
    func GenericAlert(message: String? = nil) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let thisMessage = message ?? "Oops, your reguest failed. Please check your connection and try again."
            let alert = OKAlertGenerator(alertMessage: thisMessage)
            self.present(alert.getAlertToPresent(), animated: false, completion: nil)
        }
    }
    
}
