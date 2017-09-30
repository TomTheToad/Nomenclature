//
//  CommonName+CoreDataProperties.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/29/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import Foundation
import CoreData


extension CommonName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommonName> {
        return NSFetchRequest<CommonName>(entityName: "CommonName")
    }

    @NSManaged public var name: String?
    @NSManaged public var language: String?
    @NSManaged public var belongsToOrganism: Organism?

}
