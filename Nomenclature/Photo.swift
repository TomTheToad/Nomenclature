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
    var image: UIImage?
    
    init(id: String, url: String, image: UIImage? = nil) {
        self.id = id
        self.urlString = url
        self.image = image
    }
    
    func urlForImage() -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return url
    }
}
