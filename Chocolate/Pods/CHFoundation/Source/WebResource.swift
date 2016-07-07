//
//  WebResource.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

// Reference: https://talk.objc.io/episodes/S01E01-networking

public struct WebResource<Model>: Equatable {
    
    
    // MARK: Property
    
    public let urlRequest: URLRequest
    public let parse: (json: AnyObject) -> Model?
    
    
    // MARK: Init
    
    public init(urlRequest: URLRequest, parse: (json: AnyObject) -> Model?) {
        
        self.urlRequest = urlRequest
        self.parse = parse
        
    }
    
}


// MARK: Equatable

public func == <Model>(lhs: WebResource<Model>, rhs: WebResource<Model>) -> Bool {
    
    return lhs.urlRequest == rhs.urlRequest
    
}
