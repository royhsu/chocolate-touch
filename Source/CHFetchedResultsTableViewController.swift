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

open class CHFetchedResultsTableViewController: CHTableViewController {


    // MARK: Property

    public let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    
    
    // MARK: Initializer
    
    public init(fetchedResultsController: NSFetchedResultsController<NSManagedObject>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init(style: .plain)
        
        fetchedResultsController.delegate = self
        
    }
    
    private init() {
        
        fatalError()
        
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
    
    
    // MARK: View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            try fetchedResultsController.performFetch()
            
        }
        catch {
            
            print(error.localizedDescription)
        
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections?[section]
        
        return sectionInfo?.numberOfObjects ?? 0
        
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension CHFetchedResultsTableViewController: NSFetchedResultsControllerDelegate {
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
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
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
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
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
}
