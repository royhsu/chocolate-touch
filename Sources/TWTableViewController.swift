//
//  TWTableViewController.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public enum CellHeight {
    case Automatic
    case Fixed(height: CGFloat)
}

public class TWTableViewController<Cell: UITableViewCell where Cell: Identifiable>: BaseTableViewController {
    
    
    // MARK: Property
    
    public var cellHeight: CellHeight = .Automatic { didSet { cellHeightDidSet() } }
    public var cellConfigurator: (cell: Cell, index: Int) -> Void = { _, _ in }
    public var numberOfRows = 0
    
    
    // MARK: Init
    
    public convenience init(cellType: Cell.Type) {
        
        self.init()
        
        tableView.registerCellType(cellType)
        
    }
    
    public convenience init(nibType: Cell.Type) {
        
        self.init()
        
        tableView.registerCellNib(nibType, bundle: nibBundle)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    
    }
    
    private init() { super.init(style: .Plain) }
    
    private override init(style: UITableViewStyle) { super.init(style: style) }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    public final override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return numberOfRows }
    
    public final override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return tableView.estimatedRowHeight }
    
    public final override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return tableView.rowHeight }
    
    public final override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        
        cellConfigurator(cell: cell, index: indexPath.row)
        
        return cell
        
    }

}


// MARK: - Observer

private extension TWTableViewController {
    
    private func cellHeightDidSet() {
        
        switch cellHeight {
        case .Automatic:
            
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            
        case .Fixed(let height):
            
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = height
        }
        
    }
    
}
