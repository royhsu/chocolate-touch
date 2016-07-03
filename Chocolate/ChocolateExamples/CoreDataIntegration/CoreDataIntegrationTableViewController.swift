//
//  CoreDataIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Chocolate

public class CoreDataIntegrationTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {

    let rows = [ "A", "B" ]
    
    
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
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.count }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        cell.textLabel?.text = rows[indexPath.row]
        
        return cell
        
    }
    
}
