//
//  CHCacheTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/15.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
@testable import Chocolate
import PromiseKit
import XCTest

class CHCacheTests: XCTestCase {
    
    var cache: CHCache?
    
    override func setUp() {
        super.setUp()
        
        cache = CHCache.default
        
    }
    
    override func tearDown() {
        
        cache = nil
        
        super.tearDown()
    }
    
    func testSetUpCacheStack() {
        
        let expectation = self.expectation(description: "Set up cache core data stack.")
        
        let _ =
            cache!
            .setUpCacheStack(in: .memory)
            .catch { error in
                
                XCTAssertNil(error, "Cannot set up cache stack. \(error.localizedDescription)")
            
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testInsertCaches() {
        
        let expectation = self.expectation(description: "Insert caches.")
        
        let _ =
            cache!
            .setUpCacheStack(in: .memory)
            .then { _ -> Promise<Void> in
            
                let cache1 = self.cache!.insert(
                    identifier: "test",
                    section: 0,
                    row: 0,
                    jsonObject: [ "name": "Roy" ]
                )
                
                let cache2 = self.cache!.insert(
                    identifier: "test",
                    section: 0,
                    row: 1,
                    jsonObject: [ "name": "Allen" ]
                )
                
                return when(fulfilled: cache1, cache2)
                
            }
            .then { return self.cache!.save() }
            .catch { error in
            
                XCTAssertNil(error, "Cannot insert a new cache. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
}
