//
//  Photo.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/16/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Struct created to enable easy assembly of image information.
// Accepts multiple inits with or without arguments.
// NOT included in own core data entity as this would be a 1 : 1 relationship.
// Information for associated image is stored with the Organism entity and
// built out within this struct.

import UIKit

struct Photo {

    // Thumbnail Data
    var thumbURLString: String?
    var thumbImageURL: URL? {
        guard let thisThumbURL = thumbURLString else {
            return nil
        }
        
        guard let thumbURL = URL(string: thisThumbURL) else {
            return nil
        }
        
        return thumbURL
    }

    // Image Data
    var thumbImageData: NSData?
    var thumbImage: UIImage? {
        guard let data = thumbImageData else {
            return nil
        }
        guard let image = UIImage(data: data as Data) else {
            return nil
        }
        return image
    }

    // URL Data
    var urlString: String?
    var imageURL: URL? {
        guard let thisString = urlString else {
            return nil
        }
        
        guard let url = URL(string: thisString) else {
            return nil
        }
        
        return url
    }
    
    // Image Data
    var imageData: NSData?
    var image: UIImage? {
        guard let data = imageData else {
            return nil
        }
        guard let image = UIImage(data: data as Data) else {
            return nil
        }
        return image
    }
    
    // Blank init
    init() {
        
    }
    
    // Init for return from core data
    init(imageData: NSData, thumbImageData: NSData) {
        self.imageData = imageData
        self.thumbImageData = thumbImageData
    }
    
    // Init for flikr return
    init(thumbURLString: String, url: String, imageData: NSData? = nil) {
        self.thumbURLString = thumbURLString
        self.urlString = url
        self.imageData = imageData
    }

}
