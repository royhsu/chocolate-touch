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
    
    
    // MARK: Property
    
    private let cities = [
        City(cityName: "Taipei", countryName: "Taiwan"),
        City(cityName: "Taichung", countryName: "Taiwan"),
        City(cityName: "Tinan", countryName: "Taiwan"),
        City(cityName: "Tokyo", countryName: "Japan"),
        City(cityName: "Nagoya", countryName: "Japan"),
        City(cityName: "Chiba", countryName: "Japan")
    ]
    
    
    // MARK: Init
    
    public init(modelName: String, in bundle: Bundle? = .main, at directory: Directory) {
        
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
                SortDescriptor(key: "cityName", ascending: true)
            ]
            
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: "countryName",
                cacheName: nil
            )
            
            super.init(cellType: CHTableViewCell.self, fetchedResultsController: fetchedResultsController)
            
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
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: .add
        )
        
    }
    
    
    // MARK: Action
    
    @objc public func add(barButtonItem: UIBarButtonItem) {
    
        let city = cities[Int.random(in: 0..<cities.count)]
        let cityEntity = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext) as! CityEntity
        
        cityEntity.cityName = city.cityName
        cityEntity.countryName = city.countryName
        
        managedObjectContext.perform {
        
            do { try self.managedObjectContext.save() }
            catch { fatalError("Cannot save: \(error)") }
    
        }
    
    }
    
    private func delete(at indexPath: IndexPath) {
        
        isEditing = false
        
        let city = fetchedResultsController.object(at: indexPath)
        
        managedObjectContext.perform {
            
            self.managedObjectContext.delete(city)
            
            do { try self.managedObjectContext.save() }
            catch { print("Deletion error: \(error)") }
            
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return fetchedResultsController.sections?[section].name
        
    }
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    
    // MARK: UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        return [ .delete(handler: delete) ]
        
    }
    
    
    // MARK: CHSingleCellTypeTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        let city = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = city.cityName ?? "Unknown"
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}


// MARK: - Selector

private extension Selector {
    
    static let add = #selector(CoreDataIntegrationTableViewController.add(barButtonItem:))
    
}


// MARK: - UITableViewRowAction

private extension UITableViewRowAction {
    
    static func delete(handler: (IndexPath) -> Void) -> UITableViewRowAction {
    
        return UITableViewRowAction(
            style: .default,
            title: "Delete",
            handler: { _, indexPath in handler(indexPath) }
        )
        
    }
    
}
