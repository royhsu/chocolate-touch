//
//  CHCacheSchema.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/11.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

class CHCacheSchema: CoreDataSchema {

    static var template: Template = [
        "data": .string,
        "createdAt": .date,
        "section": .string
    ]
    
}
