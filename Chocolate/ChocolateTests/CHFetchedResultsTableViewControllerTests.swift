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
        
        let nameProperty = NSAttributeDescription()
        nameProperty.name = "name"
        nameProperty.attributeType = .stringAttributeType
        nameProperty.isOptional = false
        
        let firstLetterOfName = NSAttributeDescription()
        firstLetterOfName.name = "firstLetterOfName"
        firstLetterOfName.attributeType = .stringAttributeType
        firstLetterOfName.isOptional = false
        
        let entity = NSEntityDescription()
        entity.name = "Person"
        entity.properties.append(nameProperty)
        entity.properties.append(firstLetterOfName)
        
        let model = NSManagedObjectModel()
        model.entities.append(entity)

        stack = try! CoreDataStack(name: "", model: model, options: nil, storeType: .memory)
        
    }
    
    override func tearDown() {
        
        stack = nil
        
        super.tearDown()
    }
    
    
    func testInitWithFetchRequest() {
        
        let context = stack!.viewContext
        
        let roy = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        roy.setValue("Roy", forKey: "name")
        roy.setValue("r", forKey: "firstLetterOfName")
        
        let allen = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        allen.setValue("Allen", forKey: "name")
        allen.setValue("a", forKey: "firstLetterOfName")
        
        let alex = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        alex.setValue("Alex", forKey: "name")
        alex.setValue("a", forKey: "firstLetterOfName")
        
        try! context.save()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: stack!.viewContext,
            sectionNameKeyPath: "firstLetterOfName",
            cacheName: nil
        )
        
        let fetchedResultsTableViewController = CHFetchedResultsTableViewController()
        fetchedResultsTableViewController.fetchedResultsController = fetchedResultsController
        let tableView = fetchedResultsTableViewController.tableView!
        tableView.isHidden = true
        
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2, "Number of sections doesn't match.")
        
        let numberOfRowsForFirstSection = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRowsForFirstSection, 2)
        
    }
    
}
