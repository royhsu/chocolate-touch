//
//  CHCache.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public protocol CHCacheDelegate: class {
    
    func contextDidSave()
    
}

public class CHCache {
    
    
    // MARK: Property
    
    public let identifier: String
    public let stack: CoreDataStack
    public let writerContext: NSManagedObjectContext
    public weak var delegate: CHCacheDelegate?
    
    public static let schema = CHCacheSchema()
    
    
    // MARK: Init
    
    public enum InitError: ErrorProtocol {
        case noPersistentStoreCoordinatorInContext
    }
    
    public init(identifier: String, stack: CoreDataStack) throws {
        
        guard let storeCoordinate = stack.context.persistentStoreCoordinator
            else { throw InitError.noPersistentStoreCoordinatorInContext }
        
        let writerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        writerContext.persistentStoreCoordinator = storeCoordinate
        
        self.identifier = identifier
        self.stack = stack
        self.writerContext = writerContext
        
        NotificationCenter.default.addObserver(
            self,
            selector: .contextDidSave,
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(
            self,
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
        
    }
    
    
    // MARK: Notification
    
    @objc public func contextDidSave(notification: Notification) {
        
        guard let childContext = notification.object as? NSManagedObjectContext
            else { return }
        
        guard let childStoreCoordinator = childContext.persistentStoreCoordinator
            where childStoreCoordinator === stack.storeCoordinator
            else { return }
        
        stack.context.mergeChanges(fromContextDidSave: notification)
        
        delegate?.contextDidSave()
        
    }
    
    
    // MARK: Clean Up
    
    public typealias CleanUpSuccessHandler = () -> Void
    public typealias CleanUpFailHandler = (error: ErrorProtocol) -> Void
    
    public func cleanUp(successHandler: CleanUpSuccessHandler? = nil, failHandler: CleanUpFailHandler? = nil) {
        
        let fetchRequest = CHCacheSchema.fetchRequest
        fetchRequest.predicate = Predicate(format: "id == %@", identifier)
        
        let storeRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [unowned self] result in
            
            guard let objects = result.finalResult where !objects.isEmpty else {
                
                DispatchQueue.main.async { successHandler?() }
            
                return
                
            }
            
            objects.forEach { self.writerContext.delete($0) }
            
            do {
                
                try self.writerContext.save()
                DispatchQueue.main.async { successHandler?() }
                
            }
            catch {
                
                DispatchQueue.main.async { failHandler?(error: error) }
            
            }
            
        }
        
        writerContext.performAndWait {
            
            do {
            
                try self.writerContext.execute(storeRequest)
                
            }
            catch {
                
                DispatchQueue.main.async { failHandler?(error: error) }
                
            }
            
        }
        
    }

}


// MARK: Selector

private extension Selector {
    
    static let contextDidSave = #selector(CHCache.contextDidSave)
    
}
