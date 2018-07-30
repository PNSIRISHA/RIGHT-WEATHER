//
//  ChatDataProvider.swift
//  ChatApplication
//
//  Created by Dimple Panchal on 29/05/17.
//  Copyright © 2017 CA. All rights reserved.
//

import UIKit
import CoreData
class CoreDataProvider: NSObject , NSFetchedResultsControllerDelegate {
    static  let     sharedList                      :   CoreDataProvider        =   CoreDataProvider()
    static  let     sharedDataManager               :   CoreDataManager         =   CoreDataManager()
    var             isListObject                    :   Bool                    =   false
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    // MARK:- Fetch Controller Delegates
    
    func initDataSourceForList(user_id : String){
        do {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: UserListRequest(user_id: user_id), managedObjectContext: CoreDataProvider.sharedDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
            try fetchedResultsController?.performFetch()
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    

    func UserListRequest(user_id : String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "expiry_date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return fetchRequest
    }

    

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        //        print("nee IXP")
        //print(newIndexPath)
        
        var inserted = false
        switch type {
        case .insert:
            print ("wasInserted")
            inserted = true
        default:
            print ("was updated")
            inserted = false
        }
    }
    
    func getUserDetails()->User!{
        if((fetchedResultsController?.fetchedObjects?.count)!>0){
            return fetchedResultsController?.fetchedObjects?.first as! User
        }
        return nil
    }
    
   

    
}
