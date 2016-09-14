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
    
    
    // MARK: UITableViewDataSource
    
//    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
////        return self.tableView(tableView, heightTypeForRowAt: indexPath)
//        
//    }
//        
    open func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    open func tableView(_ tableView: UITableView, containerViewForRowAt indexPath: IndexPath) -> UIView? {
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, configurationForRowAt indexPath: IndexPath) { }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
//        if
//            cell.containerView == nil,
//            let containerView = self.tableView(tableView, containerViewForRowAt: indexPath) {
//            
//            cell.setUp(containerView: containerView)
//            
//        }
//        
//        self.tableView(tableView, configurationForRowAt: indexPath)
        
        return cell
        
    }
    
}
