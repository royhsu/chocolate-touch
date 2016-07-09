//
//  CHCache.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public struct CHCache {
    
    static let shared = CHCache()
    
    
    // MARK: Clean Up
    
    public typealias CleanUpSuccessHandler = () -> Void
    public typealias CleanUpFailHandler = (error: ErrorProtocol) -> Void
    
    public static func cleanUp(fetchedResultsController: NSFetchedResultsController<NSManagedObject>, successHandler: CleanUpSuccessHandler? = nil, failHandler: CleanUpFailHandler? = nil) {
        
//        guard let objects = fetchedResultsController.fetchedObjects else {
//            
//            successHandler?()
//            
//            return
//        
//        }
//        
//        DispatchQueue.global(attributes: .qosBackground).async {
//            
//            let storeCoordinator = fetchedResultsController.managedObjectContext.persistentStoreCoordinator
//            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//            context.persistentStoreCoordinator = storeCoordinator
//            
//            context.performAndWait {
//                
//                objects.forEach { context.delete($0) }
//                
//                do {
//                    
//                    try context.save()
//                    DispatchQueue.main.async { successHandler?() }
//                
//                }
//                catch {
//                    
//                    DispatchQueue.main.async { failHandler?(error: error) }
//                
//                }
//                
//            }
//            
//        }
        
    }

}
