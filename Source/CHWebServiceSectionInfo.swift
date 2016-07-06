//
//  CHWebServiceSectionInfo.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation

public struct CHWebServiceSectionInfo<Objects: ArrayLiteralConvertible> {
    
    
    // MARK: Property
    
    public let identifier = UUID()
    public let name: String
    public let webService: WebService<Objects>
    public var errorParser: WebService<Objects>.ErrorParser?
    public var objects: Objects = []
    
    
    // MARK: Init
    
    public init(name: String, webService: WebService<Objects>, errorParser: WebService<Objects>.ErrorParser? = nil) {
        
        self.name = name
        self.webService = webService
        self.errorParser = errorParser
    
    }
    
}
