//
//  CHTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

open class CHTableViewController: UITableViewController {
    
    
    // MARK: UITableViewDataSource
    
    final override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath)
        
        if
            cell.containerView == nil,
            let containerView = self.tableView(tableView, containerViewForRowAt: indexPath) {
            
            cell.setUp(containerView: containerView)
            
        }
        
        self.tableView(tableView, configurationForRowAt: indexPath)
        
        return cell
        
    }
    
}
