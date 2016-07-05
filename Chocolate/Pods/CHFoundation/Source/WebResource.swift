//
//  WebResource.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public struct WebResource<Model> {
    
    // MARK: Property
    
    public let urlRequest: URLRequest
    public let parse: (json: AnyObject) -> Model?
    
    public init(urlRequest: URLRequest, parse: (json: AnyObject) -> Model?) {
        
        self.urlRequest = urlRequest
        self.parse = parse
        
    }
    
}
