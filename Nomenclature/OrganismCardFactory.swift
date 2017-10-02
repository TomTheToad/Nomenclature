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
        print("number of organisms in array: \(organismArray.count)")
        var cardArray = [OrganismCard]()
        for organism in organismArray {
            print("card created")
            let card = OrganismCard(organism: organism)
            print("card first common name: \(card.fetchFirstCommonName()!)")
            cardArray.append(card)
        }
        
        return cardArray
    }
    
}
