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
    
    public let services: [WebService<Any>]
    
    
    // MARK: Init
    
    public init(services: [WebService<Any>]) {
        
        self.services = services
        
    }
    
    
    // MARK: Request
    
    public func request() -> Promise<[Any]> {
        
        return Promise { fulfill, reject in
            
            let promises = services.map { $0.request() }
            
            when(fulfilled: promises)
                .then { fulfill($0) }
                .catch { reject($0) }
        
        }
        
    }
    
}
