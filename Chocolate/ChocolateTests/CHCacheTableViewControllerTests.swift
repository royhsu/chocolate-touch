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
    
    var controller: CHCacheTableViewController?
    
    let jsonObject1: [String: String] = [ "name": "Roy" ]
    let jsonObject2: [String: [String]] = [ "hobbies": [ "drawing", "basketball" ] ]
    
    override func setUp() {
        super.setUp()
        
        controller = CHCacheTableViewController(cacheIdentifier: "Test")
        controller!.webRequests = [ newTestWebRequest() ]
        controller!.dataSource = self
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
    
    func newTestWebRequest() -> CHCacheWebRequest {
        
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


// MARK: - CHTableViewDataSource

extension CHCacheTableViewControllerTests: CHTableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType {
        
        return .fixed(44.0)
        
    }
    
    func tableView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String? {
        
        return nil
        
    }
    
    func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - CHTableViewCacheDataSource

extension CHCacheTableViewControllerTests: CHTableViewCacheDataSource {
    
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
