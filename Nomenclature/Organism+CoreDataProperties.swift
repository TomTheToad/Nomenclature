//
//  Organism+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/18/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation
import CoreData


extension Organism {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organism> {
        return NSFetchRequest<Organism>(entityName: "Organism")
    }

    @NSManaged public var commonName: String?
    @NSManaged public var kingdom: String?
    @NSManaged public var phylum: String?
    @NSManaged public var sciClass: String?
    @NSManaged public var order: String?
    @NSManaged public var subOrder: String?
    @NSManaged public var family: String?
    @NSManaged public var genus: String?
    @NSManaged public var species: String?

}
