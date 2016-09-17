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

public protocol CHCacheTableViewDataSource: class {
    
    func numberOfSections() -> Int
    
    func name(for section: Int) -> String
    
    func numberOfRows(in section: Int) -> Int
    
    func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any
    
}

open class CHCacheTableViewController: CHFetchedResultsTableViewController<CHCacheEntity>, CHCacheTableViewDataSource {
    
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    
    /// For unit test.
    internal var storeType: CoreDataStack.StoreType? = nil
    
    public var isCached: Bool {
        
        let fetchedObjects = fetchedResultsController?.fetchedObjects ?? []
    
        return !fetchedObjects.isEmpty
        
    }
    public var webRequests: [CHCacheWebRequest] = []
    
    
    // MARK: Init
    
    public init(cacheIdentifier: String) {
        
        self.cacheIdentifier = cacheIdentifier
        
        super.init()
        
    }
    
    private override init() {
        
        fatalError()
    
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setUpFetchedResultsController()
        
    }
    
    
    // MARK: Set Up
    
    private func setUpFetchedResultsController() -> Promise<Void> {
        
        return
            cache
            .setUpCacheStack(in: storeType)
            .then { stack -> Void in
                
                let fetchRequest = CHCacheEntity.fetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier==%@", self.cacheIdentifier)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "createdAt", ascending: true)
                ]
                
                self.fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: stack.viewContext,
                    sectionNameKeyPath: "section",
                    cacheName: self.cacheIdentifier
                )
                
            }
            .catch { error in
                
                print(error.localizedDescription)
                
            }
        
    }
    
    
    // MARK: Web Request
    
    internal func performWebRequests() -> Promise<[Any]> {
        
        let requests = self.webRequests.map { $0.execute() }
        
        return when(fulfilled: requests)
        
    }
    
    
    // MARK: Cache
    
    internal func clearCache() -> Promise<Void> {
        
        return
            cache
            .deleteCache(with: cacheIdentifier)
            .then { return self.cache.save() }
            .then { _ -> Void in
                
                NSFetchedResultsController<CHCacheEntity>.deleteCache(withName: self.cacheIdentifier)
                
            }
        
    }
    
    internal func insertCaches(with objects: [Any]) -> Promise<Void> {
        
        let sections = self.numberOfSections()
        var insertions: [Promise<Void>] = []
        
        for section in 0..<sections {
            
            let sectionName = self.name(for: section)
            let rows = self.numberOfRows(in: section)
            
            for row in 0..<rows {
                
                let indexPath = IndexPath(row: row, section: section)
                let jsonObject = self.jsonObject(with: objects, forRowsAt: indexPath)
                
                let insertion = self.cache.insert(
                    identifier: self.cacheIdentifier,
                    section: sectionName,
                    jsonObject: jsonObject
                )
                
                insertions.append(insertion)
                
            }
            
        }
        
        return when(fulfilled: insertions)
        
    }
    
    
    // MARK: Action
    
    public final func fetch() -> Promise<Void> {
        
        return
            cache
            .setUpCacheStack(in: storeType)
            .then { _ in return self.performWebRequests() }
            .then { return self.insertCaches(with: $0) }
            .then { return self.cache.save() }
        
    }
    
    public final func refresh() -> Promise<Void> {
        
        return
            clearCache()
            .then { return self.fetch() }
        
    }


    // MARK: - CHCacheTableViewDataSource

    open func numberOfSections() -> Int {
        
        return 0
        
    }
    
    open func name(for section: Int) -> String {
        
        return "\(section)"
        
    }
    
    open func numberOfRows(in section: Int) -> Int {
        
        return 0
        
    }
    
    open func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any {
    
        return [String: Any]()
    
    }
    
}
