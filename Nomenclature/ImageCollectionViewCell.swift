//
//  ImageCollectionViewCell.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/13/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // Fields
    var photo: Photo?
    
    // IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
}
