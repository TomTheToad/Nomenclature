//
//  Image+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/5/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var url: String?
    @NSManaged public var belongsToOrganism: Organism?

}
