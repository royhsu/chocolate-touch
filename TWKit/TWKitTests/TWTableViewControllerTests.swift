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
        
        XCTAssertNotNil(controller)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let registeredCell = controller!.tableView.dequeueReusableCellWithIdentifier(TWTableViewCell.identifier, forIndexPath: indexPath) as? TWTableViewCell
        
        XCTAssertNotNil(registeredCell)
        
    }
    
    func testInitWithNibType() {
        
        let controller: TWTableViewController<TestTableViewCell>? = TWTableViewController(cellType: TestTableViewCell.self)
        
        XCTAssertNotNil(controller)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let registeredCell = controller!.tableView.dequeueReusableCellWithIdentifier(TestTableViewCell.identifier, forIndexPath: indexPath) as? TestTableViewCell
        
        XCTAssertNotNil(registeredCell)
        
    }
    
}
