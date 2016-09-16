//
//  CHCacheTableViewControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/15.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
@testable import Chocolate
import XCTest

class CHCacheTableViewControllerTests: XCTestCase {
    
    func testInitCacheTableViewControllerAndRequest() {
        
        let expectation = self.expectation(description: "Init cache table view controller and request web service groups.")
        
        let controller = CHCacheTableViewController(cacheIdentifier: "Test")
        controller.storeType = .memory
        
        let url1 = URL(string: "https://example.com")!
        let urlRequest1 = URLRequest(url: url1)
        var webService1 = WebService<Any>(urlRequest: urlRequest1)
        
        let jsonObject1: [String: String] = [ "name": "Roy" ]
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
        let jsonObject2: [String: [String]] = [ "hobbies": [ "drawing", "basketball" ] ]
        mockSession2.data = try! JSONSerialization.data(
            withJSONObject: jsonObject2,
            options: []
        )
        
        webService2.urlSession = mockSession2
        
        let webServiceGroup = WebServiceGroup(
            webServices: [ webService1, webService2 ]
        )
        
        let webRequest = CHCacheWebRequest(sectionName: "Section 1", webServiceGroup: webServiceGroup) { objects in
            
            let name = (objects[0] as! [String: Any])["name"] as! String
            let hobbies = (objects[1] as! [String: Any])["hobbies"] as! [String]
            
            return [
                "name": name,
                "hobbies": hobbies
            ]
            
        }
        
        let _ =
            controller
            .request(webRequest)
            .catch { error in
        
                XCTAssertNil(error, "Cannot request groups. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
    
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
}
