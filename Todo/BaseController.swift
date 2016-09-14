//
//  BaseController.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 14/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//



import UIKit
import CoreData



class BaseController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var timer = NSTimer()
    var pState:NSNumber = 0
    var deleting = false
    var button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        self.configureCell(cell, withObject: object)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch {

                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if !deleting
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            
            deleting = true
            button = UIButton(frame: (cell?.frame)!)
            button.backgroundColor = .redColor()
            button.setTitle("Cancel", forState: .Normal)
            button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            button.alpha = 0
            self.view.addSubview(button)
        
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
                self.button.alpha = 1
                }, completion: { finished in
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(BaseController.timerAction(_:)), userInfo:["indexPath":indexPath], repeats: false)
            })
        }
    }
    

    func timerAction(timer:NSTimer) {
        let userInfo = timer.userInfo as! Dictionary<String, AnyObject>
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.button.alpha = 0
            }, completion: { finished in
                self.deleting=false
                self.button.removeFromSuperview()
                
                let context = self.fetchedResultsController.managedObjectContext
                let object = self.fetchedResultsController.objectAtIndexPath(userInfo["indexPath"] as! NSIndexPath) as! Data
                
                if object.state == 1
                {
                    object.state = 0
                }
                else
                {
                    object.state = 1
                }
                do {
                    try context.save()
                } catch {
                    
                    //print("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
                
        })
    }
    
    func buttonAction(sender: UIButton!) {

        timer.invalidate()
        deleting=false
        button.removeFromSuperview()
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        cell.textLabel!.text = object.valueForKey("name")!.description
    }
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Data", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "state == %d", pState.integerValue)
        fetchRequest.predicate = predicate
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withObject: anObject as! NSManagedObject)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    
}

