//
//  TWTableViewController.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public enum HeightType {
    case dynamic
    case fixed(height: CGFloat)
}

public protocol TWTableViewControllerProtocol {
    
    associatedtype Cell: UITableViewCell

    func tableView(tableView: UITableView, cellHeightTypeForRowAt: NSIndexPath) -> HeightType
    
    func tableView(tableView: UITableView, configurationFor cellAtIndexPath: (cell: Cell, indexPath: NSIndexPath)) -> Cell
    
}

public class TWTableViewController<Cell: UITableViewCell where Cell: Identifiable>: BaseTableViewController, TWTableViewControllerProtocol {
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type) {
        
        super.init(style: .Plain)
        
        tableView.registerCellType(cellType)
        setupInitially()
        
    }
    
    public init(nibType: Cell.Type, bundle: NSBundle? = nil) {
        
        super.init(style: .Plain)
        
        tableView.registerCellNib(nibType, bundle: bundle)
        setupInitially()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    
    }
    
    private convenience init() { self.init(style: .Plain) }
    
    private override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
        setupInitially()
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() { }
    
    
    // MARK: UITableViewDataSource
    
    public final override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 44.0 }
    
    public final override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        let cellHeight = self.tableView(tableView, cellHeightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: return UITableViewAutomaticDimension
        case .fixed(let height): return height
        }
        
    }
    
    public final override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        
        return self.tableView(tableView, configurationFor: (cell: cell, indexPath: indexPath))
        
    }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public func tableView(tableView: UITableView, cellHeightTypeForRowAt: NSIndexPath) -> HeightType { return .dynamic }
    
    public func tableView(tableView: UITableView, configurationFor cellAtIndexPath: (cell: Cell, indexPath: NSIndexPath)) -> Cell { return cellAtIndexPath.cell }

}
