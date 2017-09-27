//
//  Photo.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/16/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

struct Photo {
    
    var id: String
    var urlString: String
    var thumbURLString: String
    var imageData: NSData?
    var thumbImageData: NSData?
    var image: UIImage? {
        guard let data = imageData else {
            return nil
        }
        guard let image = UIImage(data: data as Data) else {
            return nil
        }
        return image
    }
    
    init(id: String, thumbURLString: String, url: String, imageData: NSData? = nil) {
        self.id = id
        self.thumbURLString = thumbURLString
        self.urlString = url
        self.imageData = imageData
    }
    
    func urlForImage() -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return url
    }
    
    func urlForPhotoThumb() -> URL? {
        guard let thumbURL = URL(string: thumbURLString) else {
            return nil
        }
        
        return thumbURL
    }
    
}
