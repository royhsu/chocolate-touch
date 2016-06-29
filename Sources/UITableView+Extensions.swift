//
//  UITableView+Extensions.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func registerCellType<Cell: UITableViewCell where Cell: Identifiable>(cellType: Cell.Type) {
        
        registerClass(cellType, forCellReuseIdentifier: cellType.identifier)
        
    }
    
    func registerCellNib<Cell: UITableViewCell where Cell: Identifiable>(nibType: Cell.Type, bundle: NSBundle? = nil) {
        
        registerNib(nibType.identifier, bundle: bundle)
        
    }
    
    func registerNib(nibName: String, bundle: NSBundle? = nil) {
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        registerNib(nib, forCellReuseIdentifier: nibName)
        
    }
    
    func dequeueReusableCell<Cell: UITableViewCell where Cell: Identifiable>(for indexPath: NSIndexPath) -> Cell {
        
        return dequeueReusableCellWithIdentifier(Cell.identifier, forIndexPath: indexPath) as! Cell
        
    }
    
}
