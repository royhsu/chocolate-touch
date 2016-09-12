//
//  CHWebServiceSectionInfo.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation

public struct CHWebServiceSectionInfo<Objects: Sequence>: Equatable where Objects: ExpressibleByArrayLiteral {
    
    
    // MARK: Property
    
    public let identifier = UUID()
    public let name: String
    public let webService: WebService<Objects>
    public var objects: Objects = []

    
    // MARK: Init
    
    public init(name: String, webService: WebService<Objects>) {
        
        self.name = name
        self.webService = webService
    
    }
    
}


// MARK: Equatable

public func ==<Objects: Sequence>(lhs: CHWebServiceSectionInfo<Objects>, rhs: CHWebServiceSectionInfo<Objects>) -> Bool where Objects: ExpressibleByArrayLiteral {
    
    return lhs.identifier == rhs.identifier

}
