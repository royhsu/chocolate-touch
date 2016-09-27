//
//  CHCacheTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/15.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
@testable import Chocolate
import CoreData
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
    
    func testLoadCacheStore() {
        
        let expectation = self.expectation(description: "Load cache store.")
        
        let _ =
        cache!
            .loadStore(type: .memory)
            .catch { error in
                
                XCTAssertNil(error, "Can't load cache store. \(error.localizedDescription)")
            
            }
            .always { expectation.fulfill() }
            
            waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testInsertAndSaveCache() {
        
        let expectation = self.expectation(description: "Insert and save a cache.")
        
        let _ =
        cache!
            .loadStore(type: .memory)
            .then { _ -> Promise<NSManagedObjectID> in
            
                return self.cache!.insert(
                    identifier: "test",
                    section: 0,
                    row: 0,
                    jsonObject: [ "name": "Roy" ]
                )
                
            }
            .then { _ in return self.cache!.save() }
            .catch { error in
            
                XCTAssertNil(error, "Can't insert a new cache. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testDeleteCache() {
        
        let expectation = self.expectation(description: "Delete caches with identifier.")
        let cacheIdentifier = "test"
        
        let _ =
        cache!
            .loadStore(type: .memory)
            .then { _ -> Promise<NSManagedObjectID> in
                
                return self.cache!.insert(
                    identifier: cacheIdentifier,
                    section: 0,
                    row: 0,
                    jsonObject: [ "name": "Roy" ]
                )
                
            }
            .then { _ in return self.cache!.save() }
            .then { _ in
                
                return self.cache!.deleteCache(with: cacheIdentifier)
            
            }
            .then { _ in return self.cache!.save() }
            .catch { error in
                
                XCTAssertNil(error, "Can't delete caches. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
}
