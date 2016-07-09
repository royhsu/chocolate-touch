//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public class CHCacheTableViewController<
    Entity: NSManagedObject,
    Objects: Sequence
    where Objects: ArrayLiteralConvertible
>: CHTableViewController, NSFetchedResultsControllerDelegate, CHWebServiceControllerDelegate {
    
    
    // MARK: Property
    
    private var fetchedResultsController: NSFetchedResultsController<Entity>!
    public private(set) var webServiceController = CHWebServiceController<Objects>()
    
    
    // MARK: Init
    
    public init(fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init(style: .plain)
        
    }
    
    private init() { super.init(style: .plain) }
    
    private override init(style: UITableViewStyle) {
        
        super.init(style: style)
    
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    @objc public func contextDidSave(notification: Notification) {
        
        print("NSManagedObjectContextDidSaveNotification")
        
        guard let childContext = notification.object as? NSManagedObjectContext
            else { return }
        
        guard let childStoreCoordinator = childContext.persistentStoreCoordinator
            where childStoreCoordinator === fetchedResultsController.managedObjectContext.persistentStoreCoordinator
            else { return }
        
        DispatchQueue.main.async {
            
            childContext.mergeChanges(fromContextDidSave: notification)
            
        }
        
    }
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidSave),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )

        fetchedResultsController.delegate = self
        webServiceController.delegate = self

        do {

            try fetchedResultsController.performFetch()

            tableView.reloadData()

        }
        catch { fatalError("Cannot perform fetch: \(error)") }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController.sections?.count ?? 0

    }

    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultsController.sections else { return 0 }

        return sections[section].numberOfObjects
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.reloadData()

    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public final func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        DispatchQueue.global(attributes: .qosBackground).async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            guard let storeCoordinate = weakSelf.fetchedResultsController.managedObjectContext.persistentStoreCoordinator
                else { return }
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = storeCoordinate
            
            context.performAndWait {
                
                for object in objects {
                    
                    let _ = NSEntityDescription.insertNewObject(forEntityName: String(object.dynamicType), into: context)
                    
                }
                
                let _ = try? context.save()
                
            }
            
        }
        
    }
    
    public func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?)) {
        
    }
    
}
