//
//  ImageCell.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 10/9/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
// Specialized cell to display organism images.
// Will be necessary in future releases with multiple images in scrollView.

import UIKit

class ImageCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet var organismImageView: UIImageView!
    @IBOutlet weak var customBGView: UIView!
    
}
