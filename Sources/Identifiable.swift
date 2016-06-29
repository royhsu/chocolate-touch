//
//  Identifiable.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import TWFoundation

public protocol Identifiable {
    
    static var identifier: String { get }
    
}
