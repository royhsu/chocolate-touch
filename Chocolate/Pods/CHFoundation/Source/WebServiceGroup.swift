//
//  WebServiceGroup.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/9/16.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import PromiseKit

public struct WebServiceGroup {
    
    
    // MARK: Property
    
    public let webServices: [WebService<Any>]
    
    
    // MARK: Init
    
    public init(webServices: [WebService<Any>]) {
        
        self.webServices = webServices
        
    }
    
    
    // MARK: Request
    
    public func request() -> Promise<[Any]> {
        
        let promises = webServices.map { $0.request() }
        
        return when(fulfilled: promises)
        
    }
    
}
