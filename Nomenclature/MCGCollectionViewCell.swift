//
//  MCGCollectionViewCell.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/19/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCGCollectionViewCell: UICollectionViewCell {
    
    // Fields
    override var isSelected: Bool {
        didSet {
            if isSelected {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionImageView: UIImageView!
}
