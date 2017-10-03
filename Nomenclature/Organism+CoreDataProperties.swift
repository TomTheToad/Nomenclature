//
//  Organism+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 10/3/17.
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
    @NSManaged public var phylum: String?
    @NSManaged public var sciClass: String?
    @NSManaged public var species: String?
    @NSManaged public var thumbnailImage: NSData?
    @NSManaged public var imageURLString: String?
    @NSManaged public var thumbnailURLString: String?
    @NSManaged public var hasCommonNames: NSSet?
    @NSManaged public var withinCollection: Collection?

}

// MARK: Generated accessors for hasCommonNames
extension Organism {

    @objc(addHasCommonNamesObject:)
    @NSManaged public func addToHasCommonNames(_ value: CommonName)

    @objc(removeHasCommonNamesObject:)
    @NSManaged public func removeFromHasCommonNames(_ value: CommonName)

    @objc(addHasCommonNames:)
    @NSManaged public func addToHasCommonNames(_ values: NSSet)

    @objc(removeHasCommonNames:)
    @NSManaged public func removeFromHasCommonNames(_ values: NSSet)

}
