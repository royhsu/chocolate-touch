//
//  CHCacheTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/15.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

@testable import Chocolate
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
        
        let data = attributes["data"]
        XCTAssertNotNil(data, "Shoulde have data attribute.")
        XCTAssertEqual(data!.attributeType, .stringAttributeType, "The attribute type of data should be string.")
        XCTAssertFalse(data!.isOptional, "identifier should not be optional.")
        
        let createdAt = attributes["createdAt"]
        XCTAssertNotNil(createdAt, "Shoulde have createdAt attribute.")
        XCTAssertEqual(createdAt!.attributeType, .dateAttributeType, "The attribute type of createdAt should be date.")
        XCTAssertFalse(createdAt!.isOptional, "identifier should not be optional.")
        
    }
    
    func testSetUpCacheStack() {
        
//        cache!.setUpCacheStack()
        
    }
    
}
