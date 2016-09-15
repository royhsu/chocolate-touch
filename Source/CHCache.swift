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
    
    
    // MARK: Core Data Stack
    
    public func setUpCacheStack(in storeType: CoreDataStack.StoreType? = nil) -> Promise<CoreDataStack> {
        
        let storeType = storeType ?? .local(storeURL: defaultStoreURL)
        
        return Promise { fulfill, reject in
            
            do {
                
                let cacheModel = CHCache.createCacheModel()
                
                let stack = try CoreDataStack(
                    name: "",
                    model: cacheModel,
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
    
    internal class func createCacheModel() -> NSManagedObjectModel {
        
        let identifier = NSAttributeDescription()
        identifier.name = "identifier"
        identifier.attributeType = .stringAttributeType
        identifier.isOptional = false
        
        let section = NSAttributeDescription()
        section.name = "section"
        section.attributeType = .stringAttributeType
        section.isOptional = false
        
        let data = NSAttributeDescription()
        data.name = "data"
        data.attributeType = .stringAttributeType
        data.isOptional = false
        
        let createdAt = NSAttributeDescription()
        createdAt.name = "createdAt"
        createdAt.attributeType = .dateAttributeType
        createdAt.isOptional = false
        
        let entity = NSEntityDescription()
        entity.name = CHCacheEntity.entityName
        entity.managedObjectClassName = String(describing: CHCacheEntity.self)
        entity.properties.append(identifier)
        entity.properties.append(data)
        entity.properties.append(createdAt)
        entity.properties.append(section)
        
        let model = NSManagedObjectModel()
        model.entities.append(entity)
        
        return model
        
    }

}
