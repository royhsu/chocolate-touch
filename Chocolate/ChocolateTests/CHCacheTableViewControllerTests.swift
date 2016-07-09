//
//  CHCacheTableViewControllerTests.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
@testable import Chocolate
import CoreData
import XCTest

class CHCacheTableViewControllerTests: XCTestCase {
    
    func testSubclassingCacheTableViewController() {
        
        class TestCacheTableViewController: CHCacheTableViewController<CityEntity, [String]> {
            
            private override func viewDidLoad() {
                super.viewDidLoad()
                
                tableView.registerCellType(CHTableViewCell.self)
                
            }
            
            private override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
                return 44.0
                
            }
            
            private override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                let identifier = CHTableViewCell.identifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CHTableViewCell
                
                cell.textLabel?.text = "\(indexPath.row)"
                
                return cell
                
            }
            
        }
        
        let bundle = Bundle(for: self.dynamicType)
        let modelURL = bundle.urlForResource("Test", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        try! persistentStoreCoordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "City")
        fetchRequest.sortDescriptors = []
        
        let controller = TestCacheTableViewController(
            fetchedResultsController: NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        )
        let _ = controller.view
        
        let url = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
        let urlRequest = URLRequest(url: url)
        let webResource = WebResource<[String]>(urlRequest: urlRequest) { _ in
            
            return [ "A", "B", "C" ]
            
        }
        
        let webService = WebService(webResource: webResource)
        let section = CHWebServiceSectionInfo(name: "Section 1", webService: webService)
        
        controller.webServiceController.appendSection(section)
        
        XCTAssertNotNil(controller)
        
        let description = self.expectation(withDescription: "Request data.")
        
        controller.success = {
            
            let objects = controller.fetchedResultsController.fetchedObjects
            
            XCTAssertEqual(objects?.count, 3)
            
            description.fulfill()
            
        }
        
        controller.fail = {
            
            XCTAssert(false)
            
            description.fulfill()
            
        }
        
        controller.webServiceController.performReqeust()
        
        self.waitForExpectations(withTimeout: 10.0, handler: nil)
        
    }
    
}
