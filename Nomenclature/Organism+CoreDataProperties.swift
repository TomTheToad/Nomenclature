//
//  Organism+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/23/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation
import CoreData


extension Organism {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organism> {
        return NSFetchRequest<Organism>(entityName: "Organism")
    }

    @NSManaged public var family: String?
    @NSManaged public var genus: String?
    @NSManaged public var image: NSData?
    @NSManaged public var kingdom: String?
    @NSManaged public var order: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var phylum: String?
    @NSManaged public var sciClass: String?
    @NSManaged public var species: String?
    @NSManaged public var subOrder: String?
    @NSManaged public var thumbImage: NSData?
    @NSManaged public var vernacular: String?
    @NSManaged public var withinCollection: Collection?

}
