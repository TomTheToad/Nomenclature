//
//  Collection+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/23/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation
import CoreData


extension Collection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }

    @NSManaged public var contentDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var hasOrganism: NSSet?

}

// MARK: Generated accessors for hasOrganism
extension Collection {

    @objc(addHasOrganismObject:)
    @NSManaged public func addToHasOrganism(_ value: Organism)

    @objc(removeHasOrganismObject:)
    @NSManaged public func removeFromHasOrganism(_ value: Organism)

    @objc(addHasOrganism:)
    @NSManaged public func addToHasOrganism(_ values: NSSet)

    @objc(removeHasOrganism:)
    @NSManaged public func removeFromHasOrganism(_ values: NSSet)

}
