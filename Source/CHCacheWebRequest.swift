//
//  CHCacheWebRequest.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/16.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import PromiseKit

public struct CHCacheWebRequest {
    
    public typealias ModelBuilder = ([Any]) throws -> Any
    
    
    // MARK: Property
    
    public let sectionName: String
    public let webServiceGroup: WebServiceGroup
    public let modelBuilder: ModelBuilder
    
    
    // MARK: Init
    
    public init(sectionName: String, webServiceGroup: WebServiceGroup, modelBuilder: @escaping ModelBuilder) {
        
        self.sectionName = sectionName
        self.webServiceGroup = webServiceGroup
        self.modelBuilder = modelBuilder
        
    }
    
}
