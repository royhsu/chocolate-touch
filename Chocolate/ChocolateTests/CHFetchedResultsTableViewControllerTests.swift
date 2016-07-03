//
//  CHFetchedResultsTableViewControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
@testable import Chocolate
import XCTest

class CHFetchedResultsTableViewControllerTests: XCTestCase {
    
    var bundle: Bundle?
    var modelURL: URL?
    var model: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext?
    
    override func setUp() {
        
        super.setUp()
        
        bundle = Bundle(for: self.dynamicType)
        modelURL = bundle!.urlForResource("Test", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOf: modelURL!)
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        try! persistentStoreCoordinator!.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator!
        
    }
    
    override func tearDown() {
        
        super.tearDown()
        
    }
    
    
    func testInitWithFetchResultsController() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let controller: CHFetchedResultsTableViewController<CHTableViewCell, NSManagedObject>? = CHFetchedResultsTableViewController(
            cellType: CHTableViewCell.self,
            fetchedResultsController: fetchedResultsController
        )
        
        XCTAssertNotNil(controller, "Cannot initialize with cell type and fetched result controller")
        
    }
    
}
