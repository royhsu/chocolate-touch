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
        entity.managedObjectClassName = CHCacheEntity.className
        entity.properties.append(identifier)
        entity.properties.append(data)
        entity.properties.append(createdAt)
        entity.properties.append(section)
        
        let model = NSManagedObjectModel()
        model.entities.append(entity)
        
        return model
        
    }
    
    enum CacheError: Error {
        case stackNotReady
    }
    
    public func insert(identifier: String, section: String, jsonObject: Any) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard let stack = stack else {
                
                reject(CacheError.stackNotReady)
                
                return
            
            }
            
            do {
                
                let jsonObjectString = try String(jsonObject: jsonObject)
                
                let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                backgroundContext.parent = stack.viewContext
                
                backgroundContext.perform {
                    
                    let cache = CHCacheEntity.insert(into: backgroundContext)
                    
                    cache.identifier = identifier
                    cache.section = section
                    cache.data = jsonObjectString
                    cache.createdAt = Date()
                    
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

}
