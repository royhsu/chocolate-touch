//
//  MockWebRequest.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import Foundation

struct MockWebRequest {
    
    static let jsonObject1: [String: String] = [ "name": "Roy" ]
    static let jsonObject2: [String: [String]] = [ "hobbies": [ "drawing", "basketball" ] ]
    
    static func newWebRequest() -> CHCacheWebRequest {
        
        let url1 = URL(string: "https://example.com")!
        let urlRequest1 = URLRequest(url: url1)
        var webService1 = WebService<Any>(urlRequest: urlRequest1)
        
        let mockSession1 = MockURLSession()
        mockSession1.data = try! JSONSerialization.data(
            withJSONObject: jsonObject1,
            options: []
        )
        
        webService1.urlSession = mockSession1
        
        let url2 = URL(string: "https://example2.com")!
        let urlRequest2 = URLRequest(url: url2)
        var webService2 = WebService<Any>(urlRequest: urlRequest2)
        
        let mockSession2 = MockURLSession()
        mockSession2.data = try! JSONSerialization.data(
            withJSONObject: jsonObject2,
            options: []
        )
        
        webService2.urlSession = mockSession2
        
        let webServiceGroup = WebServiceGroup(
            webServices: [ webService1, webService2 ]
        )
        
        let webRequest = CHCacheWebRequest(webServiceGroup: webServiceGroup) { objects in
            
            let jsonObject1 = objects[0] as! [String: Any]
            let name = jsonObject1["name"] as! String
            
            let jsonObject2 = objects[1] as! [String: Any]
            let hobbies = jsonObject2["hobbies"] as! [String]
            
            return [
                "name": name,
                "hobbies": hobbies
            ]
            
        }
        
        return webRequest
        
    }
    
}
