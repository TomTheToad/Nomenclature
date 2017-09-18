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
    var imageData: NSData?
    
    init(id: String, url: String, imageData: NSData? = nil) {
        self.id = id
        self.urlString = url
        self.imageData = imageData
    }
    
    func urlForImage() -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return url
    }
}
