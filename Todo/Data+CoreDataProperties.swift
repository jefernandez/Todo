//
//  Data+CoreDataProperties.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 13/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Data {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var state: NSNumber?

}
