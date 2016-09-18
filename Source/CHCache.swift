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
    
    public private(set) var stack: CoreDataStack?
    
    private var defaultStoreURL: URL {
        
        return URL.fileURL(
            filename: Constant.filename,
            withExtension: "sqlite",
            in: .document(domainMask: .userDomainMask)
        )
        
    }
    
    public var model: NSManagedObjectModel {
        
        /// Reference: http://stackoverflow.com/questions/25088367/how-to-use-core-datas-managedobjectmodel-inside-a-framework
        let bundle = Bundle(for: type(of: self))
        
        guard
            let modelURLString = bundle.path(forResource: Constant.filename, ofType: "momd"),
            let modelURL = URL(string: modelURLString),
            let model = NSManagedObjectModel(contentsOf: modelURL)
            else { fatalError() }
        
        return model
        
    }
    
    
    // MARK: Core Data Stack
    
    public func setUpCacheStack(in storeType: CoreDataStack.StoreType? = nil) -> Promise<CoreDataStack> {
        
        let storeType = storeType ?? .local(storeURL: defaultStoreURL)
        
        return Promise { fulfill, reject in
            
            if let stack = stack {
                
                fulfill(stack)
                
                return
                
            }
            
            do {
                
                let stack = try CoreDataStack(
                    model: model,
                    options: [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                    ],
                    storeType: storeType
                )
                
                self.stack = stack
                
                fulfill(stack)
                
            }
            catch { reject(error) }
            
        }
        
    }
    
    
    // MARK: Action
    
    public enum CacheError: Error { case stackNotReady }
    
    /// Insert a new cache with automatically generated background context. If you want to keep the changes, make sure to call save method.
    public func insert(identifier: String, section: String, jsonObject: Any) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard let stack = stack else {
                
                reject(CacheError.stackNotReady)
                
                return
            
            }
            
            do {
                
                let jsonObjectString = try String(jsonObject: jsonObject)
                let backgroundContext = stack.createBackgroundContext()
                
                backgroundContext.perform {
                    
                    let cache = CHCacheEntity.insert(into: backgroundContext)
                    
                    cache.identifier = identifier
                    cache.section = section
                    cache.data = jsonObjectString
                    
                    do {
                        
                        try backgroundContext.save()
                        fulfill()
                        
                    }
                    catch { reject(error) }
                    
                }
                
            }
            catch { reject(error) }
        
        }
        
    }
    
    /// Save all changes happened on the view context.
    public func save() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard let stack = stack else {
                
                reject(CacheError.stackNotReady)
                
                return
                
            }
            
            let viewContext = stack.viewContext
            viewContext.perform {
                
                do {
                    
                    try viewContext.save()
                    fulfill()
                    
                }
                catch { reject(error) }
                
            }
        
        }
        
    }
    
    /// Delete all caches related to the given identifier.
    public func deleteCache(with identifier: String) -> Promise<Void> {
        
        return Promise { fulfill, reject in
        
            guard let stack = stack else {
                
                reject(CacheError.stackNotReady)
                
                return
                
            }
            
            let backgroundContext = stack.createBackgroundContext()
            
            backgroundContext.perform {
                
                let fetchRequest = CHCacheEntity.fetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier==%@", identifier)
                fetchRequest.sortDescriptors = []
                
                do {
                    
                    let fetchedObjects = try backgroundContext.fetch(fetchRequest)
                    
                    for object in fetchedObjects {
                        
                        backgroundContext.delete(object)
                        
                    }
                    
                    try backgroundContext.save()
                    fulfill()
                    
                }
                catch { reject(error) }
                
            }
        
        }
        
    }

}
