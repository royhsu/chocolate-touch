//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
import CHFoundation

public class CHCacheTableViewController: CHTableViewController, CHCacheDelegate, NSFetchedResultsControllerDelegate, CHWebServiceControllerDelegate {
    
    
    // MARK: Property
    
    private let cacheIdentifier: String
    private var cache: CHCache?
    
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
        
        tableView.registerCellType(CHTableViewCell.self)
        
        webServiceController.delegate = self
        
        do {
            
            let cacheStack = try setUpCacheStack(name: "Cache")
            
            cache = try setUpCache(with: cacheStack)
            
            fetchedResultsController = try setUpFetchResultsController(with: cacheStack.context)
                
            fetchData(with: fetchedResultsController!, webServiceController: webServiceController)
            
        }
        catch { /* TODO: error handling */ print("Error: \(error)") }
        
    }
    
    
    // MARK: Set Up
    
    private func setUpCacheStack(name: String) throws -> CoreDataStack {
        
        do {
            
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let storeURL = try Directory.document(mask: .userDomainMask).url
                .appendingPathComponent(name)
                .appendingPathExtension("sqlite")
            
            let model = CoreDataModel()
            let entity = CHCache.schema.entity
            model.add(entity: entity, of: CHCacheSchema.self)
            
            let stack = try CoreDataStack(
                name: name,
                model: model,
                context: context,
                options: nil,
                storeType: .local(storeURL: storeURL)
            )
            
            return stack
            
        }
        catch { throw error }
        
    }
    
    private func setUpCache(with stack: CoreDataStack) throws -> CHCache {
        
        do {
            
            let cache = try CHCache(identifier: cacheIdentifier, stack: stack)
            
            cache.delegate = self
            
            return cache
            
        }
        catch { throw error }
        
    }
    
    private func setUpFetchResultsController(with context: NSManagedObjectContext) throws -> NSFetchedResultsController<NSManagedObject> {
        
        let fetchRequest = CHCacheSchema.fetchRequest
        
        fetchRequest.predicate = Predicate(format: "id == %@", cacheIdentifier)
        
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "createdAt", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "section",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }
    
    private typealias FetchDataSuccessHandler = () -> Void
    private typealias FetchDataFailHandler = (error: ErrorProtocol) -> Void
    
    private func fetchData(with fetchedResultsController: NSFetchedResultsController<NSManagedObject>, webServiceController: CHWebServiceController<[AnyObject]>, successHandler: FetchDataSuccessHandler? = nil, failHandler: FetchDataFailHandler? = nil) {
        
        let context = fetchedResultsController.managedObjectContext
        // TODO: add background context to fetch.
        context.perform {
            
            do {
                
                let _ = try fetchedResultsController.performFetch()
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                    if let fetchedObjects = fetchedResultsController.fetchedObjects where fetchedObjects.isEmpty {
                        
                        webServiceController.performReqeust()
                        
                    }
                    
                    successHandler?()
                    
                }
                
            }
            catch {
                
                DispatchQueue.main.async { failHandler?(error: error) }
            
            }
            
        }
        
    }
    
    
    // MARK: Action
    
    public final func refreshData() {
        
        cache?.cleanUp(successHandler: { [weak self] in
        
            guard let weakSelf = self else { return }
            guard let fetchedResultsController = weakSelf.fetchedResultsController else { return }
            
            weakSelf.fetchData(with: fetchedResultsController, webServiceController: weakSelf.webServiceController)
        
        })
        
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
    
    
    // MARK: CHCacheDelegate
    
    public final func contextDidSave() { }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()

    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public final func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        guard let cache = cache else { return }
        
        cache.writerContext.performAndWait {
            
            do {
                
                let jsonObjects = objects.map { $0 as! AnyObject }
                
                for jsonObject in jsonObjects {
                    
                    let jsonString = try String(jsonObject: jsonObject)
                    
                    let _ = try CHCache.schema.insertObject(
                        with: [
                            "id": cache.identifier,
                            "data": jsonString,
                            "createdAt": Date(),
                            "section": section.name
                        ],
                        into: cache.writerContext
                    )
                    
                }
                
                try cache.writerContext.save()
                
            }
            catch {
                
                DispatchQueue.main.async {
                    
                    self.webServiceController(
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
