//
//  CoreDataStack.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/10.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public class CoreDataStack {
    
    public enum StoreType {
        case local(storeURL: URL)
        case memory
    }
    
    
    // MARK: Property
    
    /// The context in the main thread for UI displaying.
    public let viewContext: NSManagedObjectContext
    
    /// The persistent store coordinator shared by view context and writer context.
    public let storeCoordinator: NSPersistentStoreCoordinator
    
    /// The store type for persistent store coordinator.
    public let storeType: StoreType
    
    
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
    
    public init(model: NSManagedObjectModel, options: [AnyHashable: Any]? = nil, storeType: StoreType) throws {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        viewContext.persistentStoreCoordinator = storeCoordinator
        
        self.viewContext = viewContext
        self.storeCoordinator = storeCoordinator
        self.storeType = storeType
        
        do {
            
            switch storeType {
            case .local(let storeURL):
                
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                
            case .memory:
                
                try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
            }
            
        }
        catch { throw error }
        
    }
    
    
    // Todo: background add persistent store
    
}


// MARK: - Background

public extension CoreDataStack {
    
    /// A convenience method to create a new background context that targets its parent to view context.
    func createBackgroundContext() -> NSManagedObjectContext {
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = viewContext
        
        return backgroundContext
        
    }
    
}
