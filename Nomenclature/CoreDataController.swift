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
    func addOrganism(organism: Organism) {
        var thisOrganism = Organism.init(entity: Organism.entity(), insertInto: managedObjectContext)
        thisOrganism = organism
        do {
            try thisOrganism.managedObjectContext?.save()
        } catch {
            // do something
        }
    }
    
    func removeOrganism(organism: Organism) {
        managedObjectContext.delete(organism)
        
    }
}
