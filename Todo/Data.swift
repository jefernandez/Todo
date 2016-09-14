//
//  Data.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 13/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//

import Foundation
import CoreData

@objc(Data)
class Data: NSManagedObject {



    convenience init (managedObjectContext: NSManagedObjectContext, inDict:Dictionary<String,AnyObject>) {
        let entityName = "Data"
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        if let name = inDict["name"] as? String
        {
            self.name      = name
        }
        if let ident = inDict["id"] as? NSNumber
        {
            self.id      = ident
        }
        if let state = inDict["state"] as? NSNumber
        {
            self.state      = state
        }
    }
}
