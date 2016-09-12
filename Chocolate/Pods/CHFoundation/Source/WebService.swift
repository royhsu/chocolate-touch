//
//  WebService.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import PromiseKit


// MARK: - WebService

public struct WebService<Model>: Equatable {
    
    public typealias ModelParser = (Any) throws -> Model
    
    
    // MARK: Property
    
    public let urlRequest: URLRequest
    public let modelParser: ModelParser
    
    
    // MARK: Init
    
    public init(urlRequest: URLRequest, modelParser: @escaping ModelParser) {
        
        self.urlRequest = urlRequest
        self.modelParser = modelParser
        
    }
    
    
    // MARK: Request
    
    public func request(with urlSession: URLSession) -> Promise<Model> {
        
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
                .catch { error in reject(error) }
            
        }
        
    }
    
}


// MARK: - Equatable

public func ==<Model>(lhs: WebService<Model>, rhs: WebService<Model>) -> Bool {
    
    return lhs.urlRequest == rhs.urlRequest
    
}
