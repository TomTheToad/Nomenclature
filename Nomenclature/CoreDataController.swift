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
    func fetchAll() {
        
    }
    
    // 
    
}
