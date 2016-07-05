//
//  UserModel.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public struct UserModel {
    
    public let identifier: String
    public let name: String
    
    public init(identifier: String, name: String) {
    
        self.identifier = identifier
        self.name = name
    
    }
    
}
