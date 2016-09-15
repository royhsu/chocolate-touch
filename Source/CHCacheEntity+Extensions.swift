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
    
    @nonobjc public class var fetchRequest: NSFetchRequest<CHCacheEntity> {
        
        return NSFetchRequest<CHCacheEntity>(entityName: CHCacheEntity.entityName)
        
    }

}
