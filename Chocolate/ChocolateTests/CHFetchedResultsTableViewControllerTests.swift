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
        
        bundle = nil
        modelURL = nil
        model = nil
        persistentStoreCoordinator = nil
        managedObjectContext = nil
        
        super.tearDown()
        
    }
    
    func testInitWithCellTypeAndFetchResultsController() {
        
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "City")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController<CityEntity>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let controller: CHFetchedResultsTableViewController<CHTableViewCell, CityEntity>? = CHFetchedResultsTableViewController(
            cellType: CHTableViewCell.self,
            fetchedResultsController: fetchedResultsController
        )
        
        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell and fetched result controller.")
        
    }
    
    func testInitWithNibTypeAndFetchResultsController() {
        
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "City")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController<CityEntity>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let controller: CHFetchedResultsTableViewController<TestTableViewCell, CityEntity>? = CHFetchedResultsTableViewController(
            nibType: TestTableViewCell.self,
            bundle: bundle!,
            fetchedResultsController: fetchedResultsController
        )
        
        XCTAssertNotNil(controller, "Cannot initialize with custom table view cell from nib and fetched result controller.")
        
    }
    
    func testSubclassingCHFetchedResultsTableViewController() {
        
        class TestFetchedResultsTableViewController: CHFetchedResultsTableViewController<CHTableViewCell, CityEntity> {
            
            init(fetchedResultsController: NSFetchedResultsController<CityEntity>) {
                
                super.init(cellType: CHTableViewCell.self, fetchedResultsController: fetchedResultsController)
                
            }
            
            required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
            
            override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
                
                return .fixed(height: 44.0)
                
            }
            
            override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
                
                let city = fetchedResultsController.object(at: indexPath)
                
                cell.textLabel?.text = city.name
                
                return cell
            
            }
            
        }
        
        let cityNames = [
            "01:New Taipei",
            "02:Kaohsiung",
            "03:Taichung",
            "04:Taipei",
            "05:Taoyuan",
            "06:Tainan",
            "07:Hsinchu",
            "08:Keelung",
            "09:Chiayi",
            "10:Changhua",
            "11:Pingtung",
            "12:Zhubei",
            "13:Yuanlin",
            "14:Douliu",
            "15:Taitung",
            "16:Hualien",
            "17:Toufen",
            "18:Nantou",
            "19:Yilan",
            "20:Miaoli"
        ]
        
        for cityName in cityNames {

            let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext!) as! CityEntity
            city.name = cityName
            
        }
        
        managedObjectContext!.performAndWait { try! self.managedObjectContext!.save() }
        
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "City")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController<CityEntity>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let controller: TestFetchedResultsTableViewController? = TestFetchedResultsTableViewController(fetchedResultsController: fetchedResultsController)
        
        XCTAssertNotNil(controller, "Cannot initialize custom subclassing controller.")
        
        for index in 0..<Int.random(in: 0..<cityNames.count) {
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = controller!.tableView(controller!.tableView, cellForRowAt: indexPath) as? CHTableViewCell
            
            XCTAssertNotNil(cell, "The cell should not be nil.")
            
            let cellTitle = cell!.textLabel?.text
            let expectedCityName = cityNames[index]
            
            XCTAssertEqual(cellTitle, expectedCityName, "The cell title doesn't match.")
            
        }
        
    }
    
}
