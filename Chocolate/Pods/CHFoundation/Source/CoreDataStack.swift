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
     
     - Parameter name: The model name.
     
     - Parameter model: The model for stack.
     
     - Parameter options: The options for persistent store coordinator.
     
     - Parameter storeType: The persistent store coordinator store type.
     
     - Returns: A core data stack instance.
    */
    
    public init(name: String, model: NSManagedObjectModel, options: [AnyHashable: Any]? = nil, storeType: StoreType) throws {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        viewContext.persistentStoreCoordinator = storeCoordinator
        
        do {
            
            switch storeType {
            case .local(let storeURL):
                
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                
            case .memory:
                
                try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
            }
            
            self.viewContext = viewContext
            self.storeCoordinator = storeCoordinator
            self.storeType = storeType
            
        }
        catch { throw error }
        
    }
    
}
