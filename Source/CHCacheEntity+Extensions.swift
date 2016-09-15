//
//  CHCacheEntity+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/15.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public extension CHCacheEntity {
    
    class var entityName: String { return "Cache" }
    
    // Including current module name for class.
    // Reference: http://www.jessesquires.com/swift-coredata-and-testing/
    class var className: String {
        
        return NSStringFromClass(object_getClass(CHCacheEntity.self))
    
    }
    
    class func insert(into context: NSManagedObjectContext) -> CHCacheEntity {
    
        return NSEntityDescription.insertNewObject(forEntityName: CHCacheEntity.entityName, into: context) as! CHCacheEntity
    
    }
    
    @nonobjc public class var fetchRequest: NSFetchRequest<CHCacheEntity> {
        
        return NSFetchRequest<CHCacheEntity>(entityName: CHCacheEntity.entityName)
        
    }

}
