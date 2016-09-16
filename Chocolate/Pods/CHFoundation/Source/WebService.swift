//
//  WebService.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import PromiseKit


// MARK: - WebService

public struct WebService<Model> {
    
    public typealias ModelParser = (Any) throws -> Model
    
    
    // MARK: Property
    
    public var urlSession: URLSession = .shared
    public let urlRequest: URLRequest
    public let modelParser: ModelParser
    
    
    // MARK: Init
    
    public init(urlRequest: URLRequest, modelParser: ModelParser? = nil) {
        
        self.urlRequest = urlRequest
        self.modelParser = modelParser ?? WebService.defaultModelParser
        
    }
    
    
    // MARK: Model Parser
    
    private static func defaultModelParser(jsonObject: Any) throws -> Model {
        
        return jsonObject as! Model
        
    }
    
    
    // MARK: Request
    
    public func request() -> Promise<Model> {
        
        return Promise { fulfill, reject in
            
            let _ = urlSession
                .dataTask(with: self.urlRequest)
                .then { data -> Void in
                    
                    do {
                        
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        let model = try self.modelParser(jsonObject)
                        
                        fulfill(model)
                        
                    }
                    catch { reject(error) }
                    
                }
                .catch { reject($0) }
            
        }
        
    }
    
}
