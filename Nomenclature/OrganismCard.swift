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
            
            // Forced unwrapped because all allowed items set at init
            let data = [
                ("Common Name", commonName as String),
                ("Kingdom", self.kingdom!),
                ("Phylum", self.phylum!),
                ("Class", self.sciClass!),
                ("Order", self.order!),
                ("family", self.family!),
                ("genus", self.genus!),
                ("species", self.species!)
                
            ]
            return data
        }
    }
    
    var defaultLanguage = "english"
    
    init(collection: Collection, taxonomicData: NSDictionary) {
        // required field
        self.collection = collection

        for item in taxonomicData {
            let itemKey = String(describing: item.key).lowercased()
            
            if itemKey == "kingdom" {
                self.kingdom = item.value as? String ?? "missing data"
            }
            if itemKey == "phylum" {
                self.phylum = item.value as? String ?? "missing data"
            }
            if itemKey == "class" {
                self.sciClass = item.value as? String ?? "missing data"
            }
            if itemKey == "order" {
                self.order = item.value as? String ?? "missing data"
            }
            if itemKey == "family" {
                self.family = item.value as? String ?? "missing data"
            }
            if itemKey == "genus" {
                self.genus = item.value as? String ?? "missing data"
            }
            if itemKey == "species" {
                self.species = item.value as? String ?? "missing data"
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
    
    // Allow for quickly setting table data without listing each allowed variable
    // This will allow for different types of cards in the next version
//    private func setDataSource() {
//        var commonName: String = "\(defaultLanguage.uppercased()) name not found"
//        if let name = fetchFirstCommonName(language: defaultLanguage) {
//            commonName = name
//        }
//        
//        // Forced unwrapped because all allowed items set at init
//        dataSource = [
//            ("Common Name", commonName as String),
//            ("Kingdom", self.kingdom!),
//            ("Phylum", self.phylum!),
//            ("Class", self.sciClass!),
//            ("Order", self.order!),
//            ("family", self.family!),
//            ("genus", self.genus!),
//            ("species", self.species!)
//        
//        ]
//    
//    }
    
    func convertVernacularToNSObject(vernacularTupleArray: [(name: String, language: String)]) -> NSObject? {
        return vernacularTupleArray as NSObject
    }
    
}
