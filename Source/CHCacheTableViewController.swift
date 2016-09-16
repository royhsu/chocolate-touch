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

open class CHCacheTableViewController: CHFetchedResultsTableViewController<CHCacheEntity> {
    
    
    // MARK: Property
    
    let cacheIdentifier: String
    private let cache = CHCache.default
    internal var storeType: CoreDataStack.StoreType? = nil
    
    
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
    
    
    // MARK: WebServcieCroup
    
    public func request(_ webRequest: CHCacheWebRequest) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let _ =
                firstly { self.cache.setUpCacheStack() }
                .then { _ in webRequest.webServiceGroup.request() }
                .then { objects -> Void in
                    
                    do {
                        
                        let jsonObject = try webRequest.modelBuilder(objects)
                        
                        let _ =
                            self.cache
                            .insert(
                                identifier: self.cacheIdentifier,
                                section: webRequest.sectionName,
                                jsonObject: jsonObject
                            )
                            .then { _ -> Void in
                                
                                let _ = self.cache.save()
                                fulfill()
                                
                            }
                            .catch { reject($0) }
                        
                        
                    }
                    catch { reject(error) }
                    
                }
                .catch { reject($0) }
            
        }
        
    }
    
}
