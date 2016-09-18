//
//  CHCacheEntity+CoreDataClass.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/18.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation
import CoreData


public class CHCacheEntity: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        identifier = ""
        section = ""
        data = ""
        createdAt = Date()
        
    }
    
}
