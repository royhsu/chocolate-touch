//
//  CoreDataIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData

public class CoreDataIntegrationTableViewController: CHFetchedResultsTableViewController<CHTableViewCell, CityEntity> {
    
    
    // MARK: Init
    
    public init(modelName: String, in bundle: Bundle? = .main(), at directory: Directory) {
        
        guard let modelURL = bundle?.urlForResource(modelName, withExtension: "momd") else { fatalError("Invalid model url.") }
        
        do {
            
            guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
                
                fatalError("Cannot find model.")
                
            }
            
            let storeURL = try URL(filename: modelName, withExtension: "sqlite", in: directory)
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            
            let fetchRequest = NSFetchRequest<CityEntity>(entityName: "City")
            fetchRequest.sortDescriptors = [
                SortDescriptor(key: "name", ascending: true)
            ]
            
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init(cellType: CHTableViewCell.self, fetchedResultsController: fetchedResultsController)
            
            print("CoreDataIntegrationTableViewController init(modelName:in:at:)")
            
        }
        catch { fatalError("Initialization error: \(error)") }
    
    }
    
    private init() { fatalError("init() has not been implemented") }
    
    private override init(cellType: Cell.Type, fetchedResultsController: NSFetchedResultsController<CityEntity>) {
        
        super.init(cellType: cellType, fetchedResultsController: fetchedResultsController)
    
    }
    
    private override init(nibType: Cell.Type, bundle: Bundle? = nil, fetchedResultsController: NSFetchedResultsController<CityEntity>) {
    
        super.init(nibType: nibType, bundle: bundle, fetchedResultsController: fetchedResultsController)
    
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CoreDataIntegrationTableViewController viewDidLoad")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Load Data",
            style: .plain,
            target: self,
            action: .loadData
        )
        
    }
    
    
    // MARK: Action
    
    @objc public func loadData(barButtonItem: UIBarButtonItem) {
    
        let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext) as! CityEntity
        
        city.name = "Taipei"
        
        managedObjectContext.perform {
        
            do { try self.managedObjectContext.save() }
            catch { fatalError("Cannot save: \(error)") }
    
        }
    
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    
    // MARK: CHSingleCellTypeTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        let city = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = city.name ?? "Unknown"
        
        return cell
        
    }
    
}


// MARK: - Selector

private extension Selector {
    
    static let loadData = #selector(CoreDataIntegrationTableViewController.loadData(barButtonItem:))
    
}
