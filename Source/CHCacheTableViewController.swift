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

open class CHCacheTableViewController: CHFetchedResultsTableViewController<CHCacheEntity> {
    
    // Todo: Check core data before request.
    
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    
    /// For unit test.
    internal var storeType: CoreDataStack.StoreType? = nil
    
    var webRequests: [CHCacheWebRequest] = []
    
    
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
        
        setUpFetchedResultsController()
        
    }
    
    
    // MARK: Set Up
    
    private func setUpFetchedResultsController() {
        
        let _ =
            cache
            .setUpCacheStack(in: storeType)
            .then { stack -> Void in
                
                let fetchRequest = CHCacheEntity.fetchRequest
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
    
    public final func refresh() -> Promise<Void> {
        
        return
            self
            .cache
            .setUpCacheStack(in: self.storeType)
            .then { _ in return self.performWebRequests() }
            .then { objects in
                
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
            .then { return self.cache.save() }
        
    }
    
}


// MARK: - CHCacheTableViewDataSource

extension CHCacheTableViewController: CHCacheTableViewDataSource {

    public func numberOfSections() -> Int {
        
        return 0
        
    }
    
    public func name(for section: Int) -> String {
        
        return "\(section)"
        
    }
    
    public func numberOfRows(in section: Int) -> Int {
        
        return 0
        
    }
    
    public func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any {
    
        return [String: Any]()
    
    }
    
}
