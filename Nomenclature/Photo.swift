//
//  Photo.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/16/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

struct Photo {

    // Thumbnail fields
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

    // Image fields
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
    
    // init for return from core data
    init(imageData: NSData, thumbImageData: NSData) {
        self.imageData = imageData
        self.thumbImageData = thumbImageData
    }
    
    // init for flikr return
    init(thumbURLString: String, url: String, imageData: NSData? = nil) {
        self.thumbURLString = thumbURLString
        self.urlString = url
        self.imageData = imageData
    }

}
