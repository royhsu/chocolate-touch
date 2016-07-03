//
//  CoreDataIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreData
import Chocolate

public class CoreDataIntegrationTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {
    
    lazy var contextContainer: NSPersistentContainer = { NSPersistentContainer(name: "Main") }()
    lazy var fetchedResultsController: NSFetchedResultsController<CityEntity> = { [unowned self] in
        
        let fetchRequest = NSFetchRequest<CityEntity>()
        fetchRequest.sortDescriptors = []

        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.contextContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
    }()
    
    
    // MARK: Init
    
    public init() { super.init(cellType: CHTableViewCell.self) }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() { }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    
    }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        let city = fetchedResultsController.object(at: indexPath)
         
        cell.textLabel?.text = city.name
        
        return cell
        
    }
    
}
