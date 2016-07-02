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

    func tableView(_ tableView: UITableView, cellHeightTypeForRowAt: IndexPath) -> HeightType
    
    func tableView(_ tableView: UITableView, configurationFor cell: Cell, at indexPath: IndexPath) -> Cell
    
}

public class TWTableViewController<Cell: UITableViewCell where Cell: Identifiable>: BaseTableViewController, TWTableViewControllerProtocol {
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type) {
        
        super.init(style: .plain)
        
        tableView.registerCellType(cellType: cellType)
        setupInitially()
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil) {
        
        super.init(style: .plain)
        
        tableView.registerCellNibType(nibType: nibType, bundle: bundle)
        setupInitially()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    
    }
    
    private init() { super.init(style: .plain) }
    
    private override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
        setupInitially()
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() { }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, cellHeightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.estimatedRowHeight = 44.0
        case .fixed: tableView.estimatedRowHeight = 0.0
        }
        
        return tableView.estimatedRowHeight
        
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, cellHeightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.rowHeight = UITableViewAutomaticDimension
        case .fixed(let height): tableView.rowHeight = height
        }
        
        return tableView.rowHeight
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        
        return self.tableView(tableView, configurationFor: cell, at: indexPath)
        
    }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public func tableView(_ tableView: UITableView, cellHeightTypeForRowAt: IndexPath) -> HeightType { return .dynamic }
    
    public func tableView(_ tableView: UITableView, configurationFor cell: Cell, at indexPath: IndexPath) -> Cell { return cell }

}
