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
        print("CHFetchedResultsTableViewController init(cellType:fetchedResultsController:)")
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil, fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init(nibType: nibType, bundle: bundle)
        print("CHFetchedResultsTableViewController init(nibType:bundle:fetchedResultsController:)")
        
    }
    
    private init() { fatalError("init() has not been implemented") }
    
    private override init(cellType: Cell.Type) { super.init(cellType: cellType) }
    
    private override init(nibType: Cell.Type, bundle: Bundle? = nil) { super.init(nibType: nibType, bundle: bundle) }
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CHFetchedResultsTableViewController viewDidLoad")
        
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
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
        
    }
    
}
