//
//  CHFetchedResultsTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData

public class CHFetchedResultsTableViewController<Cell: UITableViewCell, Entity: NSManagedObject where Cell: Identifiable>: CHSingleCellTypeTableViewController<Cell> {

    var fetchedResultsController: NSFetchedResultsController<Entity>!
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type, fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        super.init(cellType: cellType)
        
        self.fetchedResultsController = fetchedResultsController
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil, fetchedResultsController: NSFetchedResultsController<Entity>) {
        
        super.init(nibType: nibType, bundle: bundle)
        
        self.fetchedResultsController = fetchedResultsController
        
    }
    
    private override init(cellType: Cell.Type) { super.init(cellType: cellType) }
    
    private override init(nibType: Cell.Type, bundle: Bundle? = nil) { super.init(nibType: nibType, bundle: bundle) }
    
}
