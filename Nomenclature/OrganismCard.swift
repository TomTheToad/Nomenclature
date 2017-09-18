//
//  OrganismCard.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/17/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation

struct OrganismCard {
    
    var vernacular: String
    var kingdom: String?
    var phylum: String?
    var sciClass: String?
    var order: String?
    var family: String?
    var genus: String?
    var species: String?
    
    var photo: Photo?
    
    init(vernacular: String) {
        self.vernacular = vernacular.lowercased()
    }
    
}
