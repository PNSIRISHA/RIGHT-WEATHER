//
//  NSManagedObject.swift
//  ChatApplication
//
//  Created by Dimple Panchal on 31/05/17.
//  Copyright © 2017 CA. All rights reserved.
//

import UIKit
import CoreData

func objcast<T>(obj: AnyObject) -> T {
    return obj as! T
}

extension NSManagedObject {
    
    class func createInContext(context:NSManagedObjectContext) -> Self {
        let classname = entityName()
        let object: AnyObject = NSEntityDescription.insertNewObject(forEntityName: classname, into: context)
        return objcast(obj: object)
    }
    
    class func entityName() -> String {
        let classString = NSStringFromClass(self)
        // The entity is the last component of dot-separated class name:
        let components = classString.components(separatedBy: ".").last
        return components ?? classString
    }
    
    class func deleteInContext(context:NSManagedObjectContext){
        let classname = entityName()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: classname)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}
