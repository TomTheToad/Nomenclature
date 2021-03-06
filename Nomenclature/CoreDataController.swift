//
//  CoreDataController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/7/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController {
    
    // Fields
    let allowedKeys = ["vernacular", "kingdom", "phylum", "class", "order", "family", "genus", "species"]
    let managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Internal application error")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    /* ### Helper Functions ### */
    // Get entity only necessary due to autogenerated <entityName>() apparently, still not working
    func getEntity(name: String) -> NSEntityDescription {
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext) else {
            fatalError("critical core data entity error")
        }
        return entity
    }
    
    /* ### Organism Functions ### */
    // retrieve all Organims
    // TODO: search by title?
    func fetchAllOrganismsInCollection(collection: Collection) -> [Organism]? {
        var results: [Organism]?
        
        let request = NSFetchRequest<Organism>(entityName: "Organism")
        let predicate = NSPredicate(format: "withinCollection == %@", collection)
        request.predicate = predicate
        
        do {
            results = try managedObjectContext.fetch(request)
            return results
        } catch {
            return nil
        }
    }
    
    func fetchOneOrganism(species: String) -> Organism? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Organism")
        let predicate = NSPredicate(format: "species == %@", species)
        fetchRequest.predicate = predicate
        
        do {
            return try managedObjectContext.fetch(fetchRequest).first as? Organism
        } catch {
            return nil
        }
    }
    
    // create
    func createOrganism(organismCard: OrganismCard) -> Bool {
        let entity = getEntity(name: "Organism")
        let organism = Organism(entity: entity, insertInto: managedObjectContext)
        
        // Create UUID
        organism.id = UUID().uuidString
        
        // Set collection
        organism.withinCollection = organismCard.collection
        
        // Set taxonomic data
        organism.kingdom = organismCard.kingdom
        organism.phylum = organismCard.phylum
        organism.sciClass = organismCard.sciClass // class cannot be used so sciClass substituted
        organism.order = organismCard.order
        organism.family = organismCard.family
        organism.genus = organismCard.genus
        organism.species = organismCard.species
        
        // Set Photo
        if let photo = organismCard.photo {
            organism.image = photo.imageData
            organism.imageURLString = photo.urlString
            organism.thumbnailImage = photo.thumbImageData
            organism.thumbnailURLString = photo.thumbURLString
        }
        
        // Set vernacular array
        for item in organismCard.vernacular {
            let cnEntity = getEntity(name: "CommonName")
            let commonName = CommonName(entity: cnEntity, insertInto: managedObjectContext)
            commonName.name = item.name
            commonName.language = item.language
            commonName.belongsToOrganism = organism
        }
        
        return saveData()
    }
    
    func deleteOrganism(organism: Organism) -> Bool {
        managedObjectContext.delete(organism)
        return saveData()
    }
    
    func deleteOrganism(id: String) -> Bool {
        let request = NSFetchRequest<Organism>(entityName: "Organism")
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        do {
            guard let thisOrganism = try managedObjectContext.fetch(request).first else {
                return false
            }
            managedObjectContext.delete(thisOrganism)
            return saveData()
        } catch {
            return false
        }
    }
    
    /* ### Collection Functions ### */
    
    func createCollection(title: String) -> Collection {
        let entity = getEntity(name: "Collection")
        let newCollection = Collection(entity: entity, insertInto: managedObjectContext)
        newCollection.title = title
        return newCollection
    }
    
    // Retrieve all collections
    func fetchAllCollections() -> [Collection]? {
        var results: [Collection]?
        
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        do {
            results = try managedObjectContext.fetch(request)
            return results
        } catch {
            print("fetchallCollections, nothing returned")
            return nil
        }
    }
    
    // Delete collection
    func deleteCollection(collection: Collection) -> Bool {
        managedObjectContext.delete(collection)
        
        return saveData()
    }
    
    func deleteCollections(collections: [Collection]) -> Bool {
        for collection in collections {
            managedObjectContext.delete(collection)
        }
        
        return saveData()
    }
    

    // save changes to core data
    func saveData() -> Bool {
        do {
            try managedObjectContext.save()
            return true
        } catch {
            return false
        }
    }

}

enum CoreDataControllerError: Error {
    case entityNoFound
}
