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
    
    public let webServiceGroup: WebServiceGroup
    
    /// The transform method for upcoming data.
    public let modelBuilder: ModelBuilder
    
    
    // MARK: Init
    
    public init(webServiceGroup: WebServiceGroup, modelBuilder: @escaping ModelBuilder) {
        
        self.webServiceGroup = webServiceGroup
        self.modelBuilder = modelBuilder
        
    }
    
    
    // MARK: Request
    
    /**
     Perform every requests in group, transform all of returned data into one single json object via model builder.
     
     - Returns: A transformed json object.
    */
    public func execute() -> Promise<Any> {
    
        return Promise { fulfill, reject in
            
            let _ =
                webServiceGroup
                .request()
                .then { objects -> Void in
                    
                    do {
                        
                        let jsonObject = try self.modelBuilder(objects)
                        
                        fulfill(jsonObject)
                        
                    }
                    catch { reject(error) }
                    
                }
                .catch { reject($0) }
            
        }
    
    }
    
}
