//
//  CHWebServiceCachable.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import UIKit


//UITableViewDataSource, NSFetchedResultsControllerDelegate
public protocol CHWebServiceCachable {
    
//    associatedtype Cell: UITableViewCell, Identifiable
//    associatedtype Entity: NSManagedObject
//    associatedtype Objects: Sequence, ArrayLiteralConvertible
    
//    var tableView: UITableView { get set }
//    var fetchedResultsController: NSFetchedResultsController<Entity> { get }
//    var webServiceController: CHWebServiceController<Objects> { get }
    
    init<Controller: CHTableViewController>(type: Controller.Type)
    
}


// MAKR: View Life Cycle

public extension CHWebServiceCachable {
    
//    public func viewDidLoad() {
//        
//        fetchedResultsController.delegate = self
//        
//        do {
//            
//            try fetchedResultsController.performFetch()
//            
//            tableView.reloadData()
//            
//        }
//        catch { fatalError("Cannot perform fetch: \(error)") }
//        
//    }
    
}


// MARK: UITableViewDataSource

public extension CHWebServiceCachable {
//    
//    public final func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return fetchedResultsController.sections?.count ?? 0
//        
//    }
//    
//    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        guard let sections = fetchedResultsController.sections else { return 0 }
//        
//        return sections[section].numberOfObjects
//        
//    }
//    
}


// MARK: NSFetchedResultsControllerDelegate

public extension CHWebServiceCachable {
    
//    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        
//        tableView.reloadData()
//        
//    }
    
}
