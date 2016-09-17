//
//  UITableView+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func register(_ cellClass: CHTableViewCell.Type) {
        
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
        
    }
    
    func dequeueReusableCell<Cell: CHTableViewCell>(for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        
    }
    
}
