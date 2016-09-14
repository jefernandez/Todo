
//  PendingViewController.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 13/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//

import UIKit
import CoreData



class PendingViewController: BaseController {


    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.getTodoList()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    func getTodoList()
    {
        NetworkManager.sharedInstance.getTodoList() {
            array, error in
            if (error == nil && array?.count>0)
            {
                let context = self.fetchedResultsController.managedObjectContext
                
                array!.enumerateObjectsUsingBlock({ object, index, stop in
                    let dict = object as! NSDictionary // `as!` in Swift 1.2
                    
                    let entityName = "Data"
                    let request = NSFetchRequest(entityName: entityName)
                    let predicate = NSPredicate(format: "id == %d", (dict["id"]?.intValue)!)
                    request.predicate = predicate
                    
                    do {
                        let fetchResults = try context.executeFetchRequest(request)
                        
                        //check if already exists
                        if (fetchResults.count==0)
                        {
                            let newDataObject =  Data(managedObjectContext:context, inDict: dict as! Dictionary<String, AnyObject>)
                            print (newDataObject)
                        }
                    } catch let error as NSError {
                        
                        print("Fetch failed: \(error.localizedDescription)")
                        
                    }
                    
                })
                
                do {
                    try context.save()
                } catch {
                    //print("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
        }
    }

    func nextId(managedObjectContext: NSManagedObjectContext) -> NSNumber {
        let entityName = "Data"
        let request = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(request)
            
            //check if already exists
            if (fetchResults.count>0)
            {
                let lastObject:Data = fetchResults.last as! Data
                return NSNumber(integer: lastObject.id!.integerValue + 1)
            }
            return 0
            
        } catch let error as NSError {
            
            print("Fetch failed: \(error.localizedDescription)")
            
        }
        return 0
    }

    func insertNewObject(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New TODO object", message: "Enter a name", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//            textField.text = "Some default text."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            if (textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)>0)
            {
                let context = self.fetchedResultsController.managedObjectContext
                
                let dict:NSDictionary = ["id":self.nextId(context),
                    "state":0,
                    "name": textField.text!]
                
                let newDataObject =  Data(managedObjectContext:context, inDict: dict as! Dictionary<String, AnyObject>)
                print (newDataObject)
                
                
                
                do {
                    try context.save()
                } catch {
                    //print("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}

