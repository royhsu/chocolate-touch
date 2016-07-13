//
//  CHSingleCellTypeTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public protocol CHSingleCellTypeTableViewControllerProtocol {
    
    associatedtype Cell: UITableViewCell
    
    func tableView(_ tableView: UITableView, configurationFor cell: Cell, at indexPath: IndexPath) -> Cell
    
}

public class CHSingleCellTypeTableViewController<Cell: UITableViewCell where Cell: Identifiable>: CHTableViewController, CHSingleCellTypeTableViewControllerProtocol {
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type) {
        
        super.init(style: .plain)
        
        tableView.registerCellType(cellType)
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil) {
        
        super.init(style: .plain)
        
        tableView.registerCellNibType(nibType, bundle: bundle)
        
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private init() { super.init(style: .plain) }
    
    private override init(style: UITableViewStyle) { super.init(style: style) }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() { super.viewDidLoad() }

    
    // MARK: UITableViewDataSource
    
    public final override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, heightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.estimatedRowHeight = 44.0
        case .fixed: tableView.estimatedRowHeight = 0.0
        }
        
        return tableView.estimatedRowHeight
        
    }
    
    public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, heightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.rowHeight = UITableViewAutomaticDimension
        case .fixed(let height): tableView.rowHeight = height
        }
        
        return tableView.rowHeight
        
    }
    
    public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        
        return self.tableView(tableView, configurationFor: cell, at: indexPath)
        
    }
    
    
    // MARK: CHSingleCellTypeTableViewControllerProtocol
    
    public func tableView(_ tableView: UITableView, configurationFor cell: Cell, at indexPath: IndexPath) -> Cell { return cell }

}
