//
//  CHFetchedResultsTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/12.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import UIKit

open class CHFetchedResultsTableViewController: CHTableViewController {


    // MARK: Property

    private let fetchRequest: NSFetchRequest<NSManagedObject>
    internal var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    internal var cacheStack: CoreDataStack?
    internal var storeType: CoreDataStack.StoreType {
        
        let storeURL = URL.fileURL(
            filename: "Cache",
            withExtension: "momd",
            in: .document(domainMask: .userDomainMask)
        )
        
        return .local(storeURL: storeURL)
        
    }
    
    
    // MARK: Initializer
    
    public init(fetchRequest: NSFetchRequest<NSManagedObject>) {
        
        self.fetchRequest = fetchRequest
        
        super.init(style: .plain)
        
    }
    
    private override init(style: UITableViewStyle) {
        
        fetchRequest = NSFetchRequest<NSManagedObject>()
        
        super.init(style: style)
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        fetchRequest = NSFetchRequest<NSManagedObject>()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            cacheStack = try setUpCacheStack()
            fetchedResultsController = try setUpFetchedResulsController()
        
        }
        catch { print("CHFetchedResultsTableViewController: \(error)") }
        
    }
    
    
    // MARK: Set Up
    
    private func setUpCacheStack() throws -> CoreDataStack {
        
        do {
            
            return try CoreDataStack(
                name: "Cache",
                model: NSManagedObjectModel(),
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ],
                storeType: storeType
            )
            
        }
        catch { throw error }
        
    }
    
    public enum SetUpFetchedResulsControllerError: Swift.Error {
        case noContext
    }
    
    private func setUpFetchedResulsController() throws -> NSFetchedResultsController<NSManagedObject> {
        
        guard let context = cacheStack?.viewContext
            else { throw SetUpFetchedResulsControllerError.noContext }
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return controller
        
    }
    
}
