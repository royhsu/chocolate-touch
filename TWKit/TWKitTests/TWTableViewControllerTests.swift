//
//  TWTableViewControllerTests.swift
//  TWKitTests
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import XCTest
@testable import TWKit

class TWTableViewControllerTests: XCTestCase {
    
    func testInitWithCellType() {
        
        let controller: TWTableViewController<TWTableViewCell>? = TWTableViewController(cellType: TWTableViewCell.self)
        
        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell.")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let registeredCell = controller!.tableView.dequeueReusableCellWithIdentifier(TWTableViewCell.identifier, forIndexPath: indexPath) as? TWTableViewCell
        
        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom cell after initialization.")
        
    }
    
    func testInitWithNibType() {
        
        let controller: TWTableViewController<TestTableViewCell>? = TWTableViewController(cellType: TestTableViewCell.self)
        
        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell from nib.")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let registeredCell = controller!.tableView.dequeueReusableCellWithIdentifier(TestTableViewCell.identifier, forIndexPath: indexPath) as? TestTableViewCell
        
        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom nib cell after initialization.")
        
    }
    
    func testSubclassingTWTableViewController() {
        
        class TestTableViewController: TWTableViewController<TWTableViewCell> {
            
            let rows = [ "A", "B", "C" ]
            
            init() { super.init(cellType: TWTableViewCell.self) }
            
            override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.count }
            
            override func tableView(tableView: UITableView, cellHeightTypeForRowAt: NSIndexPath) -> HeightType { return .fixed(height: 150.0) }
            
            override func tableView(tableView: UITableView, configurationFor cellAtIndexPath: (cell: TWTableViewCell, indexPath: NSIndexPath)) -> TWTableViewCell { return cellAtIndexPath.cell }
            
        }
        
        let testTableViewController: TestTableViewController? = TestTableViewController()
        
        XCTAssertNotNil(testTableViewController, "Cannot initialize custom subclassing controller.")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let registeredCell = testTableViewController?.tableView.dequeueReusableCellWithIdentifier(TWTableViewCell.identifier, forIndexPath: indexPath) as? TWTableViewCell
        
        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom cell after initialization.")
        
        XCTAssertEqual(testTableViewController?.tableView.numberOfSections, 1, "Number of sections should be default number one.")
        
        let numberOfRowsInSection = testTableViewController?.tableView.numberOfRowsInSection(0)
        
        XCTAssertEqual(numberOfRowsInSection, 3, "Number of rows in section doesn't match.")
        
        let estimatedRowHeight = testTableViewController?.tableView.estimatedRowHeight
        
        XCTAssertEqual(estimatedRowHeight, 0.0, "Estimated row height doesn't match.")
        
        let rowHeight = testTableViewController?.tableView.rowHeight
        
        XCTAssertEqual(rowHeight, 150.0, "Row height doesn't match.")
        
    }
    
}
