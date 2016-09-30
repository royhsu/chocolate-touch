//
//  CHCacheCollectionViewControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
@testable import Chocolate
import XCTest

class CHCacheCollectionViewControllerTests: XCTestCase {
    
    var controller: CHCacheCollectionViewController?
    
    override func setUp() {
        super.setUp()
        
        controller = CHCacheCollectionViewController(cacheIdentifier: "collection/123", collectionViewLayout: UICollectionViewLayout())
        controller!.webRequests = [ MockWebRequest.newWebRequest() ]
        controller!.cacheDataSource = self
        
    }
    
    override func tearDown() {
        
        controller = nil
        
        super.tearDown()
    }
    
    func testSetUpFetchedResultsController() {
        
        let expectation = self.expectation(description: "Set up fetched results controller.")
        let _ =
        controller!
            .setUpFetchedResultsController(storeType: .memory)
            .catch { error in
                
                XCTAssertNil(error, "Can't set up fetched results controller. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testPerformWebRequests() {
        
        let expectation = self.expectation(description: "Perform web requests.")
        let _ =
        controller!
            .performWebRequests()
            .then { objects in
                
                XCTAssertEqual(objects.count, 1, "The requested objects doesn't match.")
                
            }
            .catch { error in
                
                XCTAssertNil(error, "Can't perform web requests. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testInsertCaches() {
        
        let expectation = self.expectation(description: "Insert caches.")
        
        let _ =
        controller!
            .setUpFetchedResultsController(storeType: .memory)
            .then { _ in self.controller!.insertCaches(with: []) }
            .then { insertedObjects -> Void in
                
                var numberOfCaches = 0
                
                for section in 0..<self.numberOfSections() {
                    
                    for _ in 0..<self.numberOfRows(inSection: section) {
                        
                        numberOfCaches += 1
                        
                    }
                    
                }
                
                XCTAssertEqual(insertedObjects.count, numberOfCaches, "The inserted caches doesn't match cache data source.")
                
                try? self.controller!.fetchedResultsController!.performFetch()
                let fetchedObjects = self.controller!.fetchedResultsController!.fetchedObjects
                
                XCTAssertEqual(insertedObjects.count, fetchedObjects?.count, "The inserted caches doesn't match fetched objects.")
                
            }
            .catch { error in
                
                XCTAssertNil(error, "Can't insert caches. \(error.localizedDescription)")
                
            }
            .always { expectation.fulfill() }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
}


// MARK: - CHTableViewCacheDataSource

extension CHCacheCollectionViewControllerTests: CHCollectionViewCacheDataSource {
    
    func numberOfSections() -> Int {
        
        return 3
        
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        
        switch section {
        case 0: return 2
        case 1: return 3
        default: return 1
        }
        
    }
    
    func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        return nil
        
    }
    
}
