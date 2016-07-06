//
//  CHWebServiceControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

@testable import CHFoundation
@testable import Chocolate
import XCTest

class CHWebServiceControllerTests: XCTestCase {
    
    var controller: CHWebServiceController<[UserModel]>?
    var templateWebService: WebService<[UserModel]>?
    
    override func setUp() {
        super.setUp()
        
        controller = CHWebServiceController<[UserModel]>()
        
        let url = URL(string: "")!
        let urlRequest = URLRequest(url: url)
        let webResource = WebResource<[UserModel]>(urlRequest: urlRequest) { _ in
            
            let users: [UserModel]? = [
                UserModel(name: "Alleb"),
                UserModel(name: "Bob")
            ]
            
            return users
            
        }
        
        templateWebService = WebService(webResource: webResource)
        
    }
    
    override func tearDown() {
        
        controller = nil
        
        super.tearDown()
    }
    
    func testInit() {
        
        XCTAssertNotNil(controller, "Cannot intialize web service controller.")
        
    }
    
    func testAppendSection() {
        
        let section1 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 1", webService: templateWebService!)
        
        controller!.append(section: section1)
        
        let section2 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 2", webService: templateWebService!)
        
        controller!.append(section: section2)
        
        XCTAssertEqual(controller!.sections.count, 2, "The count of appened sections doesn't match.")
        
        XCTAssertEqual(controller!.pendingQueue, [ section1.identifier, section2.identifier ], "The sections inside pending queue doesn't match.")
        
        XCTAssertEqual(controller!.requestingQueue.count, 0, "The count of requesting queue doesn't match.")
        
    }
    
    func testRemoveSection() {
        
        let section1 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 1", webService: templateWebService!)
        
        controller!.append(section: section1)
        
        let request1 = Request(identifier: section1.identifier, urlSessionTask: URLSessionTask())
        
        controller!.requestingQueue.append(request1)
        
        let section2 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 2", webService: templateWebService!)
        
        controller!.append(section: section2)
        
        let section3 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 3", webService: templateWebService!)
        
        controller!.append(section: section3)
        
        let section4 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 4", webService: templateWebService!)
        
        controller!.append(section: section4)
        
        controller!.remove(section: section1)
        controller!.remove(section: section2)
        
        XCTAssertEqual(controller!.sections.count, 2, "The count of appened sections doesn't match.")
        
        XCTAssertEqual(controller!.pendingQueue, [ section3.identifier, section4.identifier ], "The sections inside pending queue doesn't match.")
        
        XCTAssertEqual(controller!.requestingQueue.count, 0, "The count of requesting queue doesn't match.")
        
    }
    
    func testRemoveRequestingForSection() {
        
        let section1 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 1", webService: templateWebService!)
        let request1 = Request(identifier: section1.identifier, urlSessionTask: URLSessionTask())
        
        let section2 = CHWebServiceSectionInfo<[UserModel]>(name: "Section 2", webService: templateWebService!)
        let request2 = Request(identifier: section2.identifier, urlSessionTask: URLSessionTask())
        
        controller!.requestingQueue = [ request1, request2 ]
        
        controller!.removeFromRequestingQueue(for: section1)
        
        XCTAssertEqual(controller!.requestingQueue, [ request2 ], "The request count of requesting queue doesn't match.")
        
    }
    
}
