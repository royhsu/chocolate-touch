//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData

open class CHCacheTableViewController: CHFetchedResultsTableViewController<CHCacheEntity> {
    
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    
    
    // MARK: Init
    
    public init?(cacheIdentifier: String) {
        
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
            .setUpCacheStack()
            .then { stack -> Void in
                
                let fetchRequest = CHCacheEntity.fetchRequest
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "createdAt", ascending: true)
                ]
                
                self.fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: stack.viewContext,
                    sectionNameKeyPath: "section",
                    cacheName: cacheIdentifier
                )
                
            }
            .catch { error in
                
                print(error.localizedDescription)
                
            }
        
    }
    
}
