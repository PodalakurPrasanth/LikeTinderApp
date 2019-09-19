//
//  ImagesList+CoreDataProperties.swift
//  DigiaptiOSTest
//
//  Created by Prasanth Podalakur on 19/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//
//

import Foundation
import CoreData


extension ImagesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagesList> {
        return NSFetchRequest<ImagesList>(entityName: "ImagesList")
    }

    @NSManaged public var image: NSData?

}
