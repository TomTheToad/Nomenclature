//
//  OrganismCardFactory.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/29/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation

class OrganismCardFactory: NSObject {
    
    func createCardArray(organismArray: [Organism]) -> [OrganismCard] {
        var cardArray = [OrganismCard]()
        for organism in organismArray {
            let card = OrganismCard(organism: organism)
            cardArray.append(card)
        }
        
        return cardArray
    }
    
}
