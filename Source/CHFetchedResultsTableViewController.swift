//
//  CHFetchedResultsTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/12.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData
import UIKit

open class CHFetchedResultsTableViewController<Entity: NSManagedObject>: CHTableViewController, NSFetchedResultsControllerDelegate {


    // MARK: Property

    public var fetchedResultsController: NSFetchedResultsController<Entity>? {
        
        didSet { fetchedResultsControllerDidSet() }
    
    }
    
    
    // MARK: Initializer
    
    public init() {
        
        super.init(style: .plain)
        
    }
    
    private override init(style: UITableViewStyle) {
        
        fatalError()
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        fatalError()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: Observer
    
    private func fetchedResultsControllerDidSet() {
        
        guard
            let fetchedResultsController = fetchedResultsController
            else {
            
                tableView.reloadData()
                
                return
            
            }
        
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        }
        catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController?.sections?.count ?? 0
        
    }
    
    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController?.sections?[section]
        
        return sectionInfo?.numberOfObjects ?? 0
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    public final func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            
            tableView.insertSections(
                IndexSet(integer: sectionIndex),
                with: .automatic
            )
            
        case .delete:
            
            tableView.deleteSections(
                IndexSet(integer: sectionIndex),
                with: .automatic
            )
            
        case .move, .update: break
        }
        
    }
    
    public final func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            tableView.insertRows(
                at: [ newIndexPath! ],
                with: .automatic
            )
            
        case .delete:
            
            tableView.deleteRows(
                at: [ indexPath! ],
                with: .automatic
            )
            
        case .move:
            
            tableView.deleteRows(
                at: [ indexPath! ],
                with: .automatic
            )
            tableView.insertRows(
                at: [ indexPath! ],
                with: .automatic
            )
            
        case .update: break
        }
        
    }
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
}
