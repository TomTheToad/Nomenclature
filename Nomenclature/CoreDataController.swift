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
    
    let managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Internal application error")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // retrieve all
    func fetchAll() -> [Organism]? {
        var results: [Organism]?
        do {
            results = try managedObjectContext.fetch(Organism.fetchRequest()) as? [Organism]
        } catch {
            return nil
        }
        return results
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
        let organism = Organism(entity: Organism.entity(), insertInto: managedObjectContext)
        for item in dict {
            let itemKey = String(describing: item.key)
            let itemValue = String(describing: item.value)
            if itemKey == "class" {
                organism.sciClass = itemValue
            } else {
                organism.setValue(itemValue, forKey: itemKey)
            }
            
            return saveData()
        }
        
        return true
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
