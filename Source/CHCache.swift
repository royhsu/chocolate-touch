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
        static let entityName = "Cache"
    }
    
    
    // MARK: Property
    
    public static let `default` = CHCache()
    
    public private(set) var stack: CoreDataStack?
    
    private var storeURL: URL {
        
        return URL.fileURL(
            filename: Constant.filename,
            withExtension: "sqlite",
            in: .document(domainMask: .userDomainMask)
        )
    
    }
    
    
    // MARK: Core Data Stack
    
    public func setUpCacheStack(in storeType: CoreDataStack.StoreType? = nil) -> Promise<Void> {
        
        let storeType = storeType ?? .local(storeURL: storeURL)
        
        return Promise { fulfill, reject in
            
            do {
                
                let cacheModel = CHCache.createCacheModel()
                
                stack = try CoreDataStack(
                    name: "",
                    model: cacheModel,
                    options: [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                    ],
                    storeType: storeType
                )
                
                fulfill()
                
            }
            catch { reject(error) }
            
        }
        
    }
    
    internal class func createCacheModel() -> NSManagedObjectModel {
        
        let identifier = NSAttributeDescription()
        identifier.name = "identifier"
        identifier.attributeType = .stringAttributeType
        identifier.isOptional = false
        
        let data = NSAttributeDescription()
        data.name = "data"
        data.attributeType = .stringAttributeType
        data.isOptional = false
        
        let createdAt = NSAttributeDescription()
        createdAt.name = "createdAt"
        createdAt.attributeType = .dateAttributeType
        createdAt.isOptional = false
        
        let entity = NSEntityDescription()
        entity.name = Constant.entityName
        entity.managedObjectClassName = Constant.entityName
        entity.properties.append(identifier)
        entity.properties.append(data)
        entity.properties.append(createdAt)
        
        let model = NSManagedObjectModel()
        model.entities.append(entity)
        
        return model
        
    }

}
