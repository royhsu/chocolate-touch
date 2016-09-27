//
//  CHCache.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import PromiseKit

public class CHCache {
    
    private struct Constant {
        static let filename = "Cache"
    }
    
    
    // MARK: Property
    
    public static let `default` = CHCache()
    
    public private(set) lazy var stack: CoreDataStack = {
        
        /// Reference: http://stackoverflow.com/questions/25088367/how-to-use-core-datas-managedobjectmodel-inside-a-framework
        let bundle = Bundle(for: type(of: self))
        
        guard
            let modelURLString = bundle.path(forResource: Constant.filename, ofType: "momd"),
            let modelURL = URL(string: modelURLString),
            let model = NSManagedObjectModel(contentsOf: modelURL)
            else {
                
                fatalError("Can't find core data model for cache.")
        
            }
        
        return CoreDataStack(model: model)
    
    }()
    
    private var defaultStoreURL: URL {
        
        return URL.fileURL(
            filename: Constant.filename,
            withExtension: "sqlite",
            in: .document(domainMask: .userDomainMask)
        )
        
    }
    
    public func loadStore(type: CoreDataStack.StoreType? = nil) -> Promise<CoreDataStack> {
    
        let storeType = type ?? .local(defaultStoreURL)
        
        return stack.loadStore(
            type: storeType,
            options: [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
        )
    
    }
    
    
    // MARK: Action
    
    /**
     Insert a new cache in background. If you want to keep the changes, make sure to call save method.
     
     - Parameter identifier: A identifier for cache.
     
     - Parameter section: The section index for cache.
     
     - Parameter row: The row index for cache.
     
     - Parameter jsonOject: A valid json object that will be converted into string for storing.
 
     - Returns: A promise with inserted managed object id.
    */
    public func insert(identifier: String, section: Int, row: Int, jsonObject: Any) -> Promise<NSManagedObjectID> {
        
        return Promise { fulfill, reject in
            
            let _ =
            self.stack.performBackgroundTask { backgroundContext in
                    
                let cache = CHCacheEntity.insert(into: backgroundContext)
                
                do {
                    
                    let jsonObjectString = try String(jsonObject: jsonObject)
                    
                    cache.identifier = identifier
                    cache.section = Int16(section)
                    cache.row = Int16(row)
                    cache.data = jsonObjectString
                    
                    try backgroundContext.save()
                    
                    fulfill(cache.objectID)
                    
                }
                catch { reject(error) }
                
            }
            
        }
        
    }
        
    
    /// Save all changes happened on the view context.
    public func save() -> Promise<NSManagedObjectContext> {
        
        return Promise { fulfill, reject in
        
            let viewContext = self.stack.viewContext
            
            viewContext.perform {
                
                do {
                    
                    try viewContext.save()
                    fulfill(viewContext)
                    
                }
                catch { reject(error) }
                
            }
        
        }
        
    }
    
    /// Delete all caches related to the given identifier.
    public func deleteCache(identifier: String) -> Promise<[NSManagedObjectID]> {
        
        return Promise { fulfill, reject in
            
            let _ =
            self.stack.performBackgroundTask { backgroundContext in
                
                let fetchRequest = CHCacheEntity.fetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier==%@", identifier)
                fetchRequest.sortDescriptors = []
                
                do {
                    
                    let fetchedObjects = try backgroundContext.fetch(fetchRequest)
                    
                    fetchedObjects.forEach { backgroundContext.delete($0) }
                    
                    try backgroundContext.save()
                    
                    let deletedObjectIDs = fetchedObjects.map { $0.objectID }
                    
                    fulfill(deletedObjectIDs)
                    
                }
                catch { reject(error) }
                
            }
        
        }
        
    }

}
