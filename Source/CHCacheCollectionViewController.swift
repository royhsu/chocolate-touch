//
//  CHCacheCollectionViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import PromiseKit


// MARK: - CHCollectionViewCacheDataSource

public protocol CHCollectionViewCacheDataSource: class {
    
    func numberOfSections() -> Int
    
    func numberOfRows(inSection section: Int) -> Int
    
    func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any?
    
}


// TODO: a expiration time for refreshing data.

// MARK: - CHCacheCollectionViewController

open class CHCacheCollectionViewController: CHCollectionViewController, CHCollectionViewCacheDataSource, NSFetchedResultsControllerDelegate {

    public enum CacheCollectionViewError: Swift.Error {
        case fetchedResultsControllerNotReady
        case invalideCaches
    }
    
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    
    public private(set) var fetchedResultsController: NSFetchedResultsController<CHCacheEntity>?
    
    public var isCached: Bool {
        
        let fetchedObjects = fetchedResultsController?.fetchedObjects ?? []
        
        return !fetchedObjects.isEmpty
        
    }
    
    public weak var cacheDataSource: CHCollectionViewCacheDataSource?
    
    /// An array that keeps all web requests.
    public var webRequests: [CHCacheWebRequest] = []
    
    
    // MARK: Init
    
    public init(cacheIdentifier: String, collectionViewLayout: UICollectionViewLayout) {
        
        self.cacheIdentifier = cacheIdentifier
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        cacheDataSource = self
        
    }
    
    private init() {
        
        fatalError()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: Set Up
    
    public final func setUpFetchedResultsController(storeType: CoreDataStack.StoreType? = nil) -> Promise<Void> {
        
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
                .then { self.performFetch() }
                .then { _ -> Promise<Void> in
                    
                    return Promise { fulfill, reject in
                        
                        let _ =
                        self.validateCaches()
                            .then { fulfill() }
                            .catch { error in
                                
                                if
                                    let error = error as? CacheCollectionViewError,
                                    error == .invalideCaches {
                                    
                                    let _ =
                                    self.clearCache()
                                        .then { self.performFetch() }
                                        .then { fulfill() }
                                        .catch { reject($0) }
                                    
                                }
                                else { reject(error) }
                                
                        }
                        
                    }
                    
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
    
    internal final func clearCache() -> Promise<Void> {
        
        return
            cache
                .deleteCache(with: cacheIdentifier)
                .then { _ in self.saveCaches() }
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
    internal final func insertCaches(with objects: [Any]) -> Promise<[NSManagedObjectID]> {
        
        let sections = cacheDataSource?.numberOfSections() ?? 0
        var insertions: [Promise<NSManagedObjectID>] = []
        
        for section in 0..<sections {
            
            let rows = cacheDataSource?.numberOfRows(inSection: section) ?? 0
            
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
    
    internal final func saveCaches() -> Promise<Void> {
        
        return cache.save().asVoid()
        
    }
    
    internal final func validateCaches() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard
                let fetchedObjects = fetchedResultsController?.fetchedObjects
                else {
                    
                    reject(CacheCollectionViewError.fetchedResultsControllerNotReady)
                    
                    return
                    
            }
            
            let sections = cacheDataSource?.numberOfSections() ?? 0
            var numberOfObjectsDefinedInDataSource = 0
            
            for section in 0..<sections {
                
                let rows = cacheDataSource?.numberOfRows(inSection: section) ?? 0
                
                for _ in 0..<rows {
                    
                    numberOfObjectsDefinedInDataSource += 1
                    
                }
                
            }
            
            if numberOfObjectsDefinedInDataSource == fetchedObjects.count {
                
                fulfill()
                
            }
            else { reject(CacheCollectionViewError.invalideCaches) }
            
        }
        
    }
    
    
    // MARK: Fetched Results Controller
    
    /// Trigger fetched results controller to perform fetching.
    internal final func performFetch() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard
                let fetchedResultsController = fetchedResultsController
                else {
                    
                    reject(CacheCollectionViewError.fetchedResultsControllerNotReady)
                    
                    return
                    
            }
            
            do {
                
                try fetchedResultsController.performFetch()
                fulfill()
                
            }
            catch { reject(error) }
            
        }
        
    }
    
    
    // MARK: Action
    
    public final func fetch() -> Promise<Void> {
        
        return
            performWebRequests()
                .then { self.insertCaches(with: $0).asVoid() }
                .then { self.saveCaches() }
                .then { self.performFetch() }
        
    }
    
    public final func refresh() -> Promise<Void> {
        
        return clearCache().then { self.fetch() }
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    public final override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return fetchedResultsController?.sections?.count ?? 0
        
    }
    
    public final override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard
            let sectionInfo = fetchedResultsController?.sections?[section]
            else { return 0 }
        
        return sectionInfo.numberOfObjects
        
    }
    
    
    // MARK: JSON Object
    
    public final func jsonObject(at indexPath: IndexPath) -> Any? {
        
        if !isCached { return nil }
        
        guard
            let cache = fetchedResultsController?.object(at: indexPath),
            let jsonObject = try? cache.data.jsonObject()
            else { return nil }
        
        return jsonObject
        
    }
    

    // MARK: CHCollectionViewCacheDataSource
    
    open func numberOfSections() -> Int {
        
        return 0
        
    }
    
    open func numberOfRows(inSection section: Int) -> Int {
        
        return 0
        
    }
    
    open func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        return nil
        
    }
    
}
