//
//  CoreDataStack.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/10.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
import PromiseKit

public class CoreDataStack {
    
    public enum StoreType {
        case local(URL)
        case memory
    }
    
    
    // MARK: Property
    
    /// The context in the main thread for UI displaying.
    public let viewContext: NSManagedObjectContext
    
    /// The persistent store coordinator shared by view context and writer context.
    public let storeCoordinator: NSPersistentStoreCoordinator
    
    /// Note: Temporarily fix the issue (error code: 134080) when adding persistent store multiple times.
    public private(set) var isStoreLoaded: Bool = false
    
    
    // MARK: Init
    
    /**
     The initializer for creating a stack instance.
     
     - Author: Roy Hsu.
     
     - Parameter model: The model for stack.
     
     - Parameter options: The options for persistent store coordinator.
     
     - Parameter storeType: The persistent store coordinator store type.
     
     - Returns: A core data stack instance.
     
     - Note: It's recommended to always create a stack on the main thread. http://stackoverflow.com/questions/13333289/core-data-timeout-adding-persistent-store-on-application-launch
     */
    public init(model: NSManagedObjectModel) {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        viewContext.persistentStoreCoordinator = storeCoordinator
        
        self.viewContext = viewContext
        self.storeCoordinator = storeCoordinator
        
    }
    
    
    /**
     The initializer for creating a stack instance.
     
     - Author: Roy Hsu.
     
     - Parameter type: The persistent store coordinator store type.
     
     - Parameter options: The options for persistent store coordinator.
     
     - Returns: A promise with stack self.
     
     */
    public func loadStore(type: StoreType, options: [AnyHashable: Any]? = nil) -> Promise<CoreDataStack> {
        
        return Promise { fulfill, reject in
            
            if isStoreLoaded {
                
                fulfill(self)
                
                return
                
            }
            
            DispatchQueue.global(qos: .background).async {
                
                switch type {
                case .local(let storeURL):
                    
                    do {
                        
                        try self.storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                        
                        self.isStoreLoaded = true
                        fulfill(self)
                        
                    }
                    catch { reject(error) }
                    
                case .memory:
                    
                    do {
                        
                        try self.storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
                        
                        self.isStoreLoaded = true
                        fulfill(self)
                        
                    }
                    catch { reject(error) }
                }
                
            }
            
        }
        
    }
    
}


// MARK: - Background

public extension CoreDataStack {
    
    /// A convenience method to create a new background context that targets its parent to view context.
    func newBackgroundContext() -> NSManagedObjectContext {
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = viewContext
        
        return backgroundContext
        
    }
    
    /// A convenience method to peform a task in background.
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) -> Promise<NSManagedObjectContext> {
        
        return Promise { fulfill, _ in
            
            let backgroundContext = self.newBackgroundContext()
            
            backgroundContext.perform {
                
                block(backgroundContext)
                fulfill(backgroundContext)
                
            }
            
        }
        
    }
    
}
