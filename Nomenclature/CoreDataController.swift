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
    
    // retrieve all
    func fetchAll() -> [Organism]? {
        var results: [Organism]?
        
        let request = NSFetchRequest<Organism>(entityName: "Organism")
        do {
            results = try managedObjectContext.fetch(request)
            return results
        } catch {
            print("fetchall, nothing returned")
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
    func addOrganism(dict: NSDictionary) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Organism", in: managedObjectContext) else {
            print("coreData: Entity error")
            return false
        }
        let organism = Organism(entity: entity, insertInto: managedObjectContext)
        
        for item in dict {
            let itemKey = String(describing: item.key)
            let itemValue = String(describing: item.value)
            if itemKey == "class" || itemKey == "Class" {
                organism.sciClass = itemValue
            } else if allowedKeys.contains(itemKey){
                organism.setValue(itemValue, forKey: itemKey)
            }
        }
        
        return saveData()
    }
    
    func removeOrganism(organism: Organism) {
        managedObjectContext.delete(organism)
        
    }
    
    func saveData() -> Bool {
        do {
            try managedObjectContext.save()
            return true
        } catch {
            print("Error: Unable to save to core data")
            return false
        }
    }
}
