//
//  NetworkManager.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 14/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//

import Foundation


public class NetworkManager: NSObject {
    
    
    //
    // Access the singleton instance
    //
    public class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }

    public func getTodoList(completionHandler: (NSArray?, NSError?) -> Void) {
        
        // Send HTTP GET Request
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: "https://dl.dropboxusercontent.com/u/6890301/tasks.json");
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        
        // Excute HTTP Request
        SpinnerView.sharedInstance.showActivityIndicator()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            SpinnerView.sharedInstance.hideActivityIndicator()
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    let array:NSArray = convertedJsonIntoDict["data"] as! NSArray
                    completionHandler(array, error)
//                    let context = self.fetchedResultsController.managedObjectContext
//                    
//                    array.enumerateObjectsUsingBlock({ object, index, stop in
//                        let dict = object as! NSDictionary // `as!` in Swift 1.2
//                        
//                        let entityName = "Data"
//                        let request = NSFetchRequest(entityName: entityName)
//                        let predicate = NSPredicate(format: "id == %d", (dict["id"]?.intValue)!)
//                        request.predicate = predicate
//                        
//                        do {
//                            let fetchResults = try context.executeFetchRequest(request)
//                            
//                            //check if already exists
//                            if (fetchResults.count==0)
//                            {
//                                let newDataObject =  Data(managedObjectContext:context, inDict: dict as! Dictionary<String, AnyObject>)
//                                print (newDataObject)
//                            }
//                        } catch let error as NSError {
//                            
//                            print("Fetch failed: \(error.localizedDescription)")
//                            
//                        }
//                        
//                    })
//                    
//                    do {
//                        try context.save()
//                    } catch {
//                        //print("Unresolved error \(error), \(error.userInfo)")
//                        abort()
//                    }
                    
                    
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
            
        }
        
        task.resume()
        
    }
    
}
