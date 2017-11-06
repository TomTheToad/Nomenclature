//
//  OrganismCard.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/17/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//
//  Class created to assemble all relevant Organism information in one place.
//  Accepts multiple init methods

import UIKit

class OrganismCard {
    
    // UUI created when saved to core Data
    var id: String?
    
    // Collection this organism belongs to
    var collection: Collection
    
    // Vernacular (common names) are associated with a language in all instances.
    typealias vernacularTuple = (name: String, language: String)
    
    // Taxonomic structure
    var vernacular = [vernacularTuple]()
    var kingdom: String?
    var phylum: String?
    var sciClass: String?
    var order: String?
    var family: String?
    var genus: String?
    var species: String?
    
    // Images stored in an instance of Photo
    var photo: Photo?
    
    // Preconfigured data source for ease of use for collections
    var dataSource: [(cellHeading: String, cellContent: String)] {
        get {
            var commonName: String = "\(defaultLanguage.uppercased()) name not found"
            if let name = fetchFirstCommonName(language: defaultLanguage) {
                commonName = name.0
            }
            
            
            let data = [
                ("Common Name", commonName as String),
                ("Kingdom", checkForNil(item: kingdom)),
                ("Phylum", checkForNil(item: phylum)),
                ("Class", checkForNil(item: sciClass)),
                ("Order", checkForNil(item: order)),
                ("Family", checkForNil(item: family)),
                ("Genus", checkForNil(item: genus)),
                ("Species", checkForNil(item: species))
                
            ]
            return data
        }
    }
    
    // Default language for search.
    // Future release: upgrade to enum
    var defaultLanguage = "english"
    
    // Init accepting Organism
    init(organism: Organism) {
        self.id = organism.id
        self.collection = organism.withinCollection! // cannot exist without a collection
        self.kingdom = organism.kingdom
        self.phylum = organism.phylum
        self.sciClass = organism.sciClass
        self.order = organism.order
        self.family = organism.family
        self.genus = organism.genus
        self.species = organism.species
        
        if let names = organism.hasCommonNames?.allObjects as? [CommonName] {
            for item in names {
                if let name = item.name, let language = item.language {
                    self.vernacular.append((name: name, language: language))
                }
            }
        } else {
            print("common name failure: organism.hasCommonNames")
        }
        
        var photo = Photo()
        photo.imageData = organism.image
        photo.urlString = organism.imageURLString
        photo.thumbImageData = organism.thumbnailImage
        photo.thumbURLString = organism.thumbnailURLString
        
        self.photo = photo
        
    }
    
    // Init accepting associated Collection and data from ITIS
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
                self.vernacular = item.value as? [vernacularTuple] ?? [(name: "missing", language: "missing")]
            }
            
        }
        
        if let photo = photo {
            self.photo = photo
        }
        
    }
    
    // Fetch the first common name, if one exists.
    func fetchFirstCommonName() -> vernacularTuple? {
        guard let first = vernacular.first else {
            return nil
        }
        return first
    }
    
    // Fetch the first common name of a particular language, if one exists.
    func fetchFirstCommonName(language: String) -> vernacularTuple? {
        let names = fetchCommonNamesByLanguage(language: language)
        return names?.first
    }
    
    // Fetch all common names by language, if they exist.
    func fetchCommonNamesByLanguage(language: String) -> [vernacularTuple]? {
        // TODO: This could lead to a nil condition
        // although technically, this should never be nil
        var namesToReturn = [vernacularTuple]()
        for name in vernacular {
            if name.language == language.lowercased() {
                namesToReturn.append(name)
            }
        }
        return namesToReturn
    }
    
    // Helper function to check for nil.
    func checkForNil(item: String?) -> String {
        guard let thisItem = item else {
            return "missing data"
        }
        return thisItem
    }
    
}
