//
//  CoreDataIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Chocolate
import CoreData

public class CoreDataIntegrationTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell>, NSFetchedResultsControllerDelegate {
    
    lazy var model: NSManagedObjectModel = {
        
        let modelURL = Bundle.main().urlForResource("Main", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    
    }()
    
    let storeURL = try! URL(filename: "Main", withExtension: "sqlite", in: .document(mask: .userDomainMask))
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { [unowned self] in
    
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        try! coordinator.addPersistentStore(
            ofType: NSSQLiteStoreType,
            configurationName: nil,
            at: self.storeURL,
            options: [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
        )
        
        return coordinator
    
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = { [unowned self] in
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
        
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject> = { [unowned self] in
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "name", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    
        controller.delegate = self
        
        return controller
    
    }()
    
    
    // MARK: Init
    
    public init() { super.init(cellType: CHTableViewCell.self) }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() {
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Load Data",
            style: .plain,
            target: self,
            action: .loadData
        )
        
        try! fetchedResultsController.performFetch()
        
        tableView.reloadData()
        
    }
    
    
    // MARK: Action
    
    @objc public func loadData(barButtonItem: UIBarButtonItem) {
        
        let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext) as! CityEntity
        city.name = "Taipei"
        
        managedObjectContext.perform { 
            
            try! self.managedObjectContext.save()
            
        }
        
        print("store url: \(storeURL)")
        
    }
    
    typealias ClearDatabaseCompletion = (error: ErrorProtocol?) -> Void
    
    @available(iOS 10.0, *)
    private func clearDatabase(contextContainer: NSPersistentContainer, completion: ClearDatabaseCompletion?) {
        

        
        completion?(error: nil)
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    
    }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        if let city = fetchedResultsController.object(at: indexPath) as? CityEntity {
        
            cell.textLabel?.text = city.name
            
        }
        
        return cell
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
        
    }
    
}


// MARK: - Selector

private extension Selector {
    
    static let loadData = #selector(CoreDataIntegrationTableViewController.loadData(barButtonItem:))
    
}
