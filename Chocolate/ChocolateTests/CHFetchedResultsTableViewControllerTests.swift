//
//  CHFetchedResultsTableViewControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
@testable import CHFoundation
@testable import Chocolate
import XCTest

class CHFetchedResultsTableViewControllerTests: XCTestCase {
    
    var stack: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        
        stack = try! CoreDataStack(name: "", model: NSManagedObjectModel(), options: nil, storeType: .memory)
        
    }
    
    override func tearDown() {
        
        stack = nil
        
        super.tearDown()
    }
    
    
    func testInitWithFetchRequest() {

        let fetchRequest = NSFetchRequest<NSManagedObject>()
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: stack!.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let fetchedResultsTableViewController = CHFetchedResultsTableViewController(fetchedResultsController: fetchedResultsController)
        
    }
    
//    func testInitWithFetchRequest() {
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>()
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "Test", ascending: true)
//        ]
//        class MockFetchedResultsTableViewController: CHFetchedResultsTableViewController {
//            
//            override var storeType: CoreDataStack.StoreType { return .memory }
//            
//        }
//        
//        let controller = MockFetchedResultsTableViewController(fetchRequest: fetchRequest)
//        controller.view.isHidden = true // Trigger viewDidLoad.
//        let cacheStack = controller.cacheStack
//        let fetchedResultsController = controller.fetchedResultsController
//        
//        XCTAssertNotNil(cacheStack, "Cache stack should be initialized.")
//        
//        XCTAssertNotNil(fetchedResultsController, "Fetched results controller should be initialized.")
//        
//        let expectedNumberOfSections = controller.tableView.numberOfSections
//        
//    }
    
}
