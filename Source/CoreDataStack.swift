//
//  CoreDataStack.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/10.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public struct CoreDataStack {
    
    let context: NSManagedObjectContext
    let storeCoordinator: NSPersistentStoreCoordinator
    let storeType: StoreType
    
    public enum StoreType {
        case local(storeURL: URL)
        case memory
    }
    
    init(name: String, model: NSManagedObjectModel, context: NSManagedObjectContext, options: [NSObject: AnyObject]? = nil, storeType: StoreType) throws {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context.persistentStoreCoordinator = storeCoordinator
        
        do {
            
            switch storeType {
            case .local(let storeURL):
                
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                
            case .memory:
                
                try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
            }
            
            self.context = context
            self.storeCoordinator = storeCoordinator
            self.storeType = storeType
            
        }
        catch { throw error }
        
    }
    
}
