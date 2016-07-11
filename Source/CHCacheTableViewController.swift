//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
import CHFoundation

public class CHCacheTableViewController<
    Objects: Sequence
    where Objects: ArrayLiteralConvertible
>: CHTableViewController, NSFetchedResultsControllerDelegate, CHWebServiceControllerDelegate {
    
    
    // MARK: Property
    
    private let cacheSchema = CHCacheSchema()
    private var cacheStack: CoreDataStack?
    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    public private(set) var webServiceController = CHWebServiceController<Objects>()
    
    
    // MARK: Init
    
    public init() { super.init(style: .plain) }
    
    private override init(style: UITableViewStyle) {
        
        super.init(style: style)
    
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: .contextDidSave,
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
        
        tableView.registerCellType(CHTableViewCell.self)
        
        webServiceController.delegate = self
        
        do {
            
            let name = "Cache"
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let storeURL = try Directory.document(mask: .userDomainMask).url
                .appendingPathComponent(name)
                .appendingPathExtension("sqlite")
            
            print("Debug: \(storeURL)")
            
            let model = CoreDataModel()
            model.add(entity: cacheSchema.entity, of: CHCacheSchema.self)
            
            cacheStack = try CoreDataStack(
                name: name,
                model: model,
                context: context,
                options: nil,
                storeType: .local(storeURL: storeURL)
            )
            
            let fetchRequest = CHCacheSchema.fetchRequest
            fetchRequest.sortDescriptors = [
                SortDescriptor(key: "createdAt", ascending: true)
            ]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: "section",
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
            
            context.perform {
                
                do {
                    
                    let _ = try self.fetchedResultsController?.performFetch()
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                        
                        if let fetchedObjects = self.fetchedResultsController?.fetchedObjects where fetchedObjects.isEmpty {
                            
                            self.webServiceController.performReqeust()
                            
                        }
                        
                    }
                    
                }
                catch { /* TODO: error handling */ print("Error: \(error)") }
                
            }
            
        }
        catch { /* TODO: error handling */ print("Error: \(error)") }
        
    }
    
    
    // MARK: Notification
    
    @objc public func contextDidSave(notification: Notification) {
        
        guard let childContext = notification.object as? NSManagedObjectContext
            else { return }
        
        guard let childStoreCoordinator = childContext.persistentStoreCoordinator
            where childStoreCoordinator === fetchedResultsController?.managedObjectContext.persistentStoreCoordinator
            else { return }
        
        DispatchQueue.main.async {
            
            if childContext.hasChanges {
                
                childContext.mergeChanges(fromContextDidSave: notification)
                
            }
            else { self.tableView.reloadData() }
            
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController?.sections?.count ?? 0

    }

    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultsController?.sections else { return 0 }

        return sections[section].numberOfObjects
        
    }
    
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CHTableViewCell.identifier, for: indexPath) as! CHTableViewCell
        
        if let object = fetchedResultsController?.object(at: indexPath) {
            
            cell.textLabel?.text = object.value(forKey: "data") as? String
            
        }
        
        return cell
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()

    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public final func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        DispatchQueue.global(attributes: .qosBackground).async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            guard let storeCoordinate = weakSelf.fetchedResultsController?.managedObjectContext.persistentStoreCoordinator
                else { return }
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = storeCoordinate
            
            context.performAndWait {
                
                do {
                    
                    for _ in objects {
                        
                        let _ = try weakSelf.cacheSchema.insertObject(
                            with: [
                                "data": "Hello",
                                "createdAt": Date(),
                                "section": "itunesSearching"
                            ],
                            into: context
                        )
                        
                    }
                    
                    try context.save()
                
                }
                catch {
                
                    weakSelf.webServiceController(
                        controller,
                        didRequest: section,
                        withFail: (statusCode: nil, error: error)
                    )
                
                }
                
            }
            
        }
        
    }
    
    public func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?)) {
        
        print("Error: \(result.error)")
        
    }
    
}


// MARK: Selector

private extension Selector {
    
    static let contextDidSave = #selector(CHCacheTableViewController.contextDidSave)
    
}
