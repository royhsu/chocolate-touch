//
//  CHCacheEntity+CoreDataProperties.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/18.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation
import CoreData


extension CHCacheEntity {

    @NSManaged public var createdAt: Date
    @NSManaged public var data: String
    @NSManaged public var identifier: String
    @NSManaged public var row: Int16
    @NSManaged public var section: Int16
    
}
