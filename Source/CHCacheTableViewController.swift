//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import PromiseKit


// MARK: - CHCacheTableViewDataSource

public protocol CHTableViewCacheDataSource: class {
    
    func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any?
    
}

open class CHCacheTableViewController: CHTableViewController, NSFetchedResultsControllerDelegate {
    
    // Todo: a expiration time for refreshing data.
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    
    public private(set) var fetchedResultsController: NSFetchedResultsController<CHCacheEntity>?
    
    public var isCached: Bool {
        
        let fetchedObjects = fetchedResultsController?.fetchedObjects ?? []
    
        return !fetchedObjects.isEmpty
        
    }
    
    public weak var cacheDataSource: CHTableViewCacheDataSource?
    
    /// An array that keeps all web requests.
    public var webRequests: [CHCacheWebRequest] = []
    
    
    // MARK: Init
    
    public init(cacheIdentifier: String) {
        
        self.cacheIdentifier = cacheIdentifier
        
        super.init(style: .plain)
        
        cacheDataSource = self
        
    }
    
    private init() {
        
        fatalError()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: Set Up
    
    public func setUpFetchedResultsController(storeType: CoreDataStack.StoreType? = nil) -> Promise<Void> {
        
        return
            cache
            .loadStore(type: storeType)
            .then { stack -> Void in
                
                let fetchRequest = CHCacheEntity.fetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier==%@", self.cacheIdentifier)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "section", ascending: true),
                    NSSortDescriptor(key: "row", ascending: true)
                ]
                
                let fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: stack.viewContext,
                    sectionNameKeyPath: "section",
                    cacheName: self.cacheIdentifier
                )
                
                fetchedResultsController.delegate = self
                
                self.fetchedResultsController = fetchedResultsController
                
            }
            .catch { error in
                
                print(error.localizedDescription)
                
            }
        
    }
    
    
    // MARK: Web Request
    
    /** 
     Perform all requests inside the webRequests property.
     
     - Returns: A promise object carries all transformed json objects for web requests.
     
     - Note: Please use this method the excute all the web requests instead of request them individually.
    */
    internal func performWebRequests() -> Promise<[Any]> {
        
        let requests = self.webRequests.map { $0.execute() }
        
        return when(fulfilled: requests)
        
    }
    
    
    // MARK: Cache
    
    internal func clearCache() -> Promise<Void> {
        
        return
            cache
            .deleteCache(identifier: cacheIdentifier)
            .then { _ in return self.cache.save() }
            .then { _ -> Void in
                
                NSFetchedResultsController<CHCacheEntity>.deleteCache(withName: self.cacheIdentifier)
                
            }
        
    }
    
    /**
     Insert caches based on provided CHCacheTableViewDataSource.
     
     - Parameter objects: All feeding json objects for CHCacheTableViewDataSource.
     
     - Returns: A promise object.
     
     - Note: Please make sure to call save method on the cache context manually if you want to keep the insertions.
    */
    internal func insertCaches(with objects: [Any]) -> Promise<[NSManagedObjectID]> {
        
        let sections = tableView.numberOfSections
        var insertions: [Promise<NSManagedObjectID>] = []
        
        for section in 0..<sections {
            
            let rows = tableView.numberOfRows(inSection: section)
            
            for row in 0..<rows {
                
                let indexPath = IndexPath(row: row, section: section)
                let jsonObject =
                    cacheDataSource?.jsonObject(with: objects, forRowsAt: indexPath) ??
                    [AnyHashable: Any]()
                
                let insertion = cache.insert(
                    identifier: cacheIdentifier,
                    section: section,
                    row: row,
                    jsonObject: jsonObject
                )
                
                insertions.append(insertion)
                
            }
            
        }
        
        return when(fulfilled: insertions)
        
    }
    
    
    // MARK: Action
    
    /// Execute all required methods to request and cache data.
    public final func fetch() -> Promise<NSManagedObjectContext> {
        
        return
            cache
            .loadStore()
            .then { _ in return self.performWebRequests() }
            .then { return self.insertCaches(with: $0) }
            .then { _ in return self.cache.save() }
        
    }
    
    /// Clean up previous caches and re-fetch data. Nicely cooperate with UIRefreshControl.
    public final func refresh() -> Promise<NSManagedObjectContext> {
        
        return
            clearCache()
            .then { return self.fetch() }
        
    }

    
    // MARK: UITableViewDataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        
        return super.numberOfSections(in: tableView)
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return super.tableView(tableView, numberOfRowsInSection: section)
        
    }
    
}


// MARK: - CHTableViewCacheDataSource

extension CHCacheTableViewController: CHTableViewCacheDataSource {
    
    open func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        return nil
        
    }
    
}
