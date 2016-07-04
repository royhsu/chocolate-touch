//
//  CHFetchedResultsTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public class CHFetchedResultsTableViewController<Cell: UITableViewCell, Entity: NSManagedObject where Cell: Identifiable>: CHSingleCellTypeTableViewController<Cell>, NSFetchedResultsControllerDelegate {
    
    
    // MARK: Property
    
    public var fetchedResultsController: NSFetchedResultsController<Entity>!
    public var managedObjectContext: NSManagedObjectContext { return fetchedResultsController.managedObjectContext }
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type, fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init(cellType: cellType)
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil, fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init(nibType: nibType, bundle: bundle)
        
    }
    
    private init() { fatalError("init() has not been implemented") }
    
    private override init(cellType: Cell.Type) { super.init(cellType: cellType) }
    
    private override init(nibType: Cell.Type, bundle: Bundle? = nil) { super.init(nibType: nibType, bundle: bundle) }
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
            tableView.reloadData()
            
        }
        catch { fatalError("Cannot perform fetch: \(error)") }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    public final func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            
            tableView.insertSections(IndexSet(index: sectionIndex), with: .automatic )
            
        case .delete:
            
            tableView.deleteSections(IndexSet(index: sectionIndex), with: .automatic)
            
        case .move, .update: break
        }
        
    }
    
    public final func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .update:
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
}
