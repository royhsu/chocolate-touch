//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
import CHFoundation

public class CHCacheTableViewController: CHTableViewController, NSFetchedResultsControllerDelegate, CHWebServiceControllerDelegate {
    
    
    // MARK: Property
    
    private let cacheSchema = CHCacheSchema()
    private var cacheStack: CoreDataStack?
    public let cacheIdentifier: String
    
    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    public private(set) var webServiceController = CHWebServiceController<[AnyObject]>()
    
    
    // MARK: Init
    
    public init(cacheIdentifier: String) {
        
        self.cacheIdentifier = cacheIdentifier
    
        super.init(style: .plain)
        
    }
    
    private init() {
        
        self.cacheIdentifier = ""
        
        super.init(style: .plain)
    
    }
    
    private override init(style: UITableViewStyle) {
        
        self.cacheIdentifier = ""
        
        super.init(style: style)
    
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        self.cacheIdentifier = ""
        
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
            
            fetchRequest.predicate = Predicate(format: "id == %@", cacheIdentifier)
            
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
        
        fetchedResultsController?.managedObjectContext.mergeChanges(fromContextDidSave: notification)
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController?.sections?.count ?? 0

    }

    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultsController?.sections else { return 0 }

        return sections[section].numberOfObjects
        
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultsController?.sections else { return nil }
        
        return sections[section].name
        
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CHTableViewCell.identifier, for: indexPath) as! CHTableViewCell
        
        if let object = fetchedResultsController?.object(at: indexPath),
            let jsonString = object.value(forKey: "data") as? String,
            let jsonObject = try? jsonString.jsonObject() as? [NSObject: AnyObject] {
            
            cell.textLabel?.text = jsonObject?["trackName"] as? String
            
        }
        
        return cell
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()

    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public final func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        let jsonObjects = objects.map { $0 as! AnyObject }
        
        DispatchQueue.global(attributes: .qosBackground).async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            guard let storeCoordinate = weakSelf.fetchedResultsController?.managedObjectContext.persistentStoreCoordinator
                else { return }
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = storeCoordinate
            
            context.performAndWait {
                
                do {
                    
                    for jsonObject in jsonObjects {
                        
                        let jsonString = try String(jsonObject: jsonObject)
                        
                        let _ = try weakSelf.cacheSchema.insertObject(
                            with: [
                                "id": weakSelf.cacheIdentifier,
                                "data": jsonString,
                                "createdAt": Date(),
                                "section": section.name
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


// MARK: Strings

public extension String {
    
    public enum JSONError: ErrorProtocol {
        case fail(Encoding)
    }
    
    public init(jsonObject: AnyObject, encoding: Encoding = .utf8) throws {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            guard let jsonString = String(data: data, encoding: encoding)
                else { throw JSONError.fail(encoding) }
            
            self = jsonString
            
        }
        catch { throw error }
        
    }
    
    public func jsonObject(with encoding: Encoding = .utf8, allowLossyConversion isLossy: Bool = true) throws -> AnyObject {
        
        guard let data = self.data(using: encoding, allowLossyConversion: isLossy)
            else { throw JSONError.fail(encoding) }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            return json
            
        }
        catch { throw error }
        
    }
    
}
