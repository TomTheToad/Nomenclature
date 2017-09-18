//
//  ImageSearchController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/13/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class ImageSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Fields
    let flikr = FlickrAPIController()
    // TODO: update this to a struct or NSManagedObjectClass
    var searchString = String()
    var receivedPhotos: [Photo]?
    
    // TODO: create an image entity
    var imagesReturned: [NSDictionary]?
    var selectedPhoto: Photo?
    
    // IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // IBActions
    @IBAction func addImageButton(_ sender: Any) {
        performSegue(withIdentifier: "saveToDetailVC", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: update with nil testing and Organism struct of NSManagedObject
        // pass more info for flikr?

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.allowsSelection = true
        imageCollectionView.allowsMultipleSelection = false
        
        searchTextField.text = searchString

    }
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = receivedPhotos?.count else {
            // TODO: Alert Error
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
        
        if let imageData = photo.imageData {
            cell.backgroundColor = UIColor.blue
            cell.imageView.image = UIImage(data: imageData as Data)
            cell.photo = photo
        } else if let url = photo.urlForImage() {
            flikr.downloadImageFromFlikrURL(url: url, completionHandler: {
                (data, response, error) in
                if error == nil {
                    guard let imageData = data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        cell.backgroundColor = UIColor.blue
                        cell.imageView.image = UIImage(data: imageData)
                        photo.imageData = imageData as NSData
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
    
}
