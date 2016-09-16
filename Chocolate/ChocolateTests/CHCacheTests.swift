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
    
    func testCreateCacheModel() {
        
        let model = CHCache.createCacheModel()
        
        let cache = model.entitiesByName["Cache"]
        XCTAssertNotNil(cache, "Should have Cache entity.")
        
        let attributes = cache!.attributesByName
        
        let identifier = attributes["identifier"]
        XCTAssertNotNil(identifier, "Shoulde have identifier attribute.")
        XCTAssertEqual(identifier!.attributeType, .stringAttributeType, "The attribute type of identifier should be string.")
        XCTAssertFalse(identifier!.isOptional, "identifier should not be optional.")
        
        let section = attributes["section"]
        XCTAssertNotNil(section, "Shoulde have section attribute.")
        XCTAssertEqual(section!.attributeType, .stringAttributeType, "The attribute type of section should be string.")
        XCTAssertFalse(section!.isOptional, "section should not be optional.")
        
        let data = attributes["data"]
        XCTAssertNotNil(data, "Shoulde have data attribute.")
        XCTAssertEqual(data!.attributeType, .stringAttributeType, "The attribute type of data should be string.")
        XCTAssertFalse(data!.isOptional, "data should not be optional.")
        
        let createdAt = attributes["createdAt"]
        XCTAssertNotNil(createdAt, "Shoulde have createdAt attribute.")
        XCTAssertEqual(createdAt!.attributeType, .dateAttributeType, "The attribute type of createdAt should be date.")
        XCTAssertFalse(createdAt!.isOptional, "createdAt should not be optional.")
        
    }
    
    func testSetUpCacheStack() {
        
        let expectation = self.expectation(description: "Set up cache core data stack.")
        
        let _ =
            cache!
            .setUpCacheStack(in: .memory)
            .catch { error in
                
                XCTAssertNil(error, "Cannot set up cache stack \(error.localizedDescription).")
            
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
                    section: "section 1",
                    jsonObject: [ "name": "Roy" ]
                )
                
                let cache2 = self.cache!.insert(
                    identifier: "test",
                    section: "section 1",
                    jsonObject: [ "name": "Allen" ]
                )
                
                return when(fulfilled: cache1, cache2)
                
            }
            .then { return self.cache!.save() }
            .catch { error in
            
                XCTAssertNil(error, "Cannot insert a new cache \(error.localizedDescription).")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
}
