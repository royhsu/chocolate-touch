//
//  CHSingleCellTypeTableViewControllerTests.swift
//  ChocolateTests
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

@testable import Chocolate
import XCTest

class CHSingleCellTypeTableViewControllerTests: XCTestCase {
    
    var bundle: Bundle?
    
    override func setUp() {
        
        super.setUp()
        
        bundle = Bundle(for: type(of: self))
        
    }
    
    override func tearDown() {
        
        bundle = nil
        
        super.tearDown()
        
    }
    
    func testInitWithCellType() {
//        
//        let controller: CHSingleCellTypeTableViewController<CHTableViewCell>? = CHSingleCellTypeTableViewController(cellType: CHTableViewCell.self)
//        
//        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell.")
//        
//        let indexPath = IndexPath(row: 0, section: 0)
//        let registeredCell = controller!.tableView.dequeueReusableCell(withIdentifier: CHTableViewCell.identifier, for: indexPath) as? CHTableViewCell
//        
//        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom table view cell after initialization.")
        
    }
    
    func testInitWithNibType() {
        
//        let controller: CHSingleCellTypeTableViewController<TestTableViewCell>? = CHSingleCellTypeTableViewController(nibType: TestTableViewCell.self, bundle: bundle!)
//        
//        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell from nib.")
//        
//        let indexPath = IndexPath(row: 0, section: 0)
//        let registeredCell = controller!.tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as? TestTableViewCell
//        
//        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom nib table view cell after initialization.")
        
    }
    
//    func testSubclassingCHSingleCellTypeTableViewController() {
//        
//        class TestTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {
//            
//            let rows = [ "A", "B", "C" ]
//            
//            init() { super.init(cellType: CHTableViewCell.self) }
//            
//            required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//            
//            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.count }
//            
//            override func tableView(_ tableView: UITableView, heightTypeForRowAt cellHeightTypeForRowAt: IndexPath) -> HeightType { return .fixed(height: 150.0) }
//            
//            override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell { return cell }
//            
//        }
//        
//        let testTableViewController: TestTableViewController? = TestTableViewController()
//        
//        XCTAssertNotNil(testTableViewController, "Cannot initialize custom subclassing controller.")
//        
//        let indexPath = IndexPath(row: 0, section: 0)
//        let registeredCell = testTableViewController?.tableView.dequeueReusableCell(withIdentifier: CHTableViewCell.identifier, for: indexPath) as? CHTableViewCell
//        
//        XCTAssertNotNil(registeredCell, "Cannot retrieve the custom table view cell after initialization.")
//        
//        XCTAssertEqual(testTableViewController?.tableView.numberOfSections, 1, "Number of sections should be default number one.")
//        
//        let numberOfRowsInSection = testTableViewController?.tableView.numberOfRows(inSection: 0)
//        
//        XCTAssertEqual(numberOfRowsInSection, 3, "Number of rows in section doesn't match.")
//        
//        let estimatedRowHeight = testTableViewController?.tableView.estimatedRowHeight
//        
//        XCTAssertEqual(estimatedRowHeight, 0.0, "Estimated row height doesn't match.")
//        
//        let rowHeight = testTableViewController?.tableView.rowHeight
//        
//        XCTAssertEqual(rowHeight, 150.0, "Row height doesn't match.")
//        
//    }
    
}
