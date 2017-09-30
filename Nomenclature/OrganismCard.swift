//
//  OrganismCard.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/17/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

struct OrganismCard {
    
    // Collection this organism belongs to
    var collection: Collection
    
    // Taxonomic structure
    var vernacular: [(name: String, language: String)]?
    var kingdom: String?
    var phylum: String?
    var sciClass: String?
    var order: String?
    var family: String?
    var genus: String?
    var species: String?
    
    // Images
    var photo: Photo?
    
    var dataSource: [(cellHeading: String, cellContent: String)] {
        get {
            var commonName: String = "\(defaultLanguage.uppercased()) name not found"
            if let name = fetchFirstCommonName(language: defaultLanguage) {
                commonName = name
            }
            
            
            let data = [
                ("Common Name", commonName as String),
                ("Kingdom", checkForNil(item: kingdom)),
                ("Phylum", checkForNil(item: phylum)),
                ("Class", checkForNil(item: sciClass)),
                ("Order", checkForNil(item: order)),
                ("family", checkForNil(item: family)),
                ("genus", checkForNil(item: genus)),
                ("species", checkForNil(item: species))
                
            ]
            return data
        }
    }
    
    var defaultLanguage = "english"
    
    init(organism: Organism) {
        self.collection = organism.withinCollection! // cannot exist without a collection
        self.kingdom = organism.kingdom
        self.phylum = organism.phylum
        self.sciClass = organism.sciClass
        self.order = organism.order
        self.family = organism.family
        self.genus = organism.genus
        self.species = organism.species
        
        guard let names = organism.hasCommonNames?.allObjects as? [CommonName] else {
            self.vernacular = [(name: "missing", language: "missing")]
            return
        }
        
        for item in names {
            if let name = item.name, let language = item.language {
                self.vernacular?.append((name: name, language: language))
            }
        }
    }
    
    init(collection: Collection, taxonomicData: NSDictionary) {
        // required field
        self.collection = collection

        for item in taxonomicData {
            let itemKey = String(describing: item.key).lowercased()
            
            if itemKey == "kingdom" {
                self.kingdom = (item.value as? String ?? "missing data")
            }
            if itemKey == "phylum" {
                self.phylum = (item.value as? String ?? "missing data")
            }
            if itemKey == "class" {
                self.sciClass = (item.value as? String ?? "missing data")
            }
            if itemKey == "order" {
                self.order = (item.value as? String ?? "missing data")
            }
            if itemKey == "family" {
                self.family = (item.value as? String ?? "missing data")
            }
            if itemKey == "genus" {
                self.genus = (item.value as? String ?? "missing data")
            }
            if itemKey == "species" {
                self.species = (item.value as? String ?? "missing data")
            }
            
            if itemKey == "vernacular" {
                self.vernacular = item.value as? [(name: String, language: String)] ?? [(name: "missing", language: "missing")]
            }
            
        }
        
        if let photo = photo {
            self.photo = photo
        }
        
    }
    
    func fetchFirstCommonName() -> (String, String)? {
        guard let first = vernacular?.first else {
            return nil
        }
        return first
    }
    
    func fetchFirstCommonName(language: String) -> String? {
        let names = fetchCommonNamesByLanguage(language: language)
        return names?.first
    }
    
    func fetchCommonNamesByLanguage(language: String) -> [String]? {
        guard let names = vernacular else {
            return nil
        }
        
        var namesToReturn = [String]()
        for name in names {
            if name.language == language.lowercased() {
                namesToReturn.append(name.name)
            }
        }
        return namesToReturn
    }
    
    func checkForNil(item: String?) -> String {
        guard let thisItem = item else {
            return "missing data"
        }
        return thisItem
    }
    
}
