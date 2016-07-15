//
//  CHCache.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData

public class CHCache {
    
    
    // MARK: Property
    
    public let identifier: String
    public let stack: CoreDataStack
    
    public static let schema = CHCacheSchema()
    
    
    // MARK: Init
    
    public init(identifier: String, stack: CoreDataStack) {
        
        self.identifier = identifier
        self.stack = stack
        
    }
    
    
    // MARK: Clean Up
    
    public typealias CleanUpSuccessHandler = () -> Void
    public typealias CleanUpFailHandler = (error: ErrorProtocol) -> Void
    
    public func cleanUp(successHandler: CleanUpSuccessHandler? = nil, failHandler: CleanUpFailHandler? = nil) {
        
        let fetchRequest = CHCacheSchema.fetchRequest
        fetchRequest.predicate = Predicate(format: "id == %@", identifier)
        
        let writerContext = stack.writerContext
        
        let storeRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            
            guard let objects = result.finalResult where !objects.isEmpty else {
                
                DispatchQueue.main.async { successHandler?() }
            
                return
                
            }
            
            objects.forEach { writerContext.delete($0) }
            
            do {
                
                try writerContext.save()
                DispatchQueue.main.async { successHandler?() }
                
            }
            catch {
                
                DispatchQueue.main.async { failHandler?(error: error) }
            
            }
            
        }
        
        writerContext.performAndWait {
            
            do {
            
                try writerContext.execute(storeRequest)
                
            }
            catch {
                
                DispatchQueue.main.async { failHandler?(error: error) }
                
            }
            
        }
        
    }

}

