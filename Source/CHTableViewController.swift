//
//  CHTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

open class CHTableViewController: UITableViewController {
    
    public enum HeightType {
        case dynamic
        case fixed(height: CGFloat)
    }
    
    
    // MARK: View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CHTableViewCell.self)
        
    }
    
    
    // MARK: UITableViewDataSource
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, heightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.rowHeight = UITableViewAutomaticDimension
        case .fixed(let height): tableView.rowHeight = height
        }
        
        return tableView.rowHeight
        
    }
        
    open func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    open func tableView(_ tableView: UITableView, containerViewForRowAt indexPath: IndexPath) -> UIView? {
        
        return nil
        
    }
    
    open func configure(cell: CHTableViewCell, forRowAt indexPath: IndexPath) { }
    
    public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath)
        
        if
            cell.containerView == nil,
            let containerView = self.tableView(tableView, containerViewForRowAt: indexPath) {
            
            cell.setUp(containerView: containerView)
            
        }
        
        self.configure(cell: cell, forRowAt: indexPath)
        
        return cell
        
    }
    
}
