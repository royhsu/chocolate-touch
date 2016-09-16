//
//  MockURLSession.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/9/11.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public class MockURLSession: URLSession {
    
    public var data: Data? = nil
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        
        completionHandler(data, nil, nil)
        
        return MockURLSessionDataTask()
        
    }
    
}

public class MockURLSessionDataTask: URLSessionDataTask {
    
    public override func resume() { }
    
}
