//
//  ImageDataSet+CoreDataProperties.swift
//  HW_4
//
//  Created by Valerie Guch on January 2022
//
//

import Foundation
import CoreData


extension ImageDataSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDataSet> {
        return NSFetchRequest<ImageDataSet>(entityName: "ImageDataSet")
    }

    @NSManaged public var label: String?

}

extension ImageDataSet : Identifiable {

}
