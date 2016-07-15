//
//  UITableView+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import UIKit

public extension UITableView {
    
    func registerCellType<Cell: UITableViewCell where Cell: Identifiable>(_ cellType: Cell.Type) {
        
        register(cellType, forCellReuseIdentifier: cellType.identifier)
        
    }
    
    func registerCellNibType<Cell: UITableViewCell where Cell: Identifiable>(_ nibType: Cell.Type, bundle: Bundle? = nil) {
        
        registerNib(nibName: nibType.identifier, bundle: bundle)
        
    }
    
    func registerNib(nibName: String, bundle: Bundle? = nil) {
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: nibName)
        
    }
    
    func dequeueReusableCell<Cell: UITableViewCell where Cell: Identifiable>(for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        
    }
    
    func cellForRow<Cell: UITableViewCell where Cell: Identifiable>(at indexPath: IndexPath) -> Cell? {
        
        return cellForRow(at: indexPath) as? Cell
        
    }
    
}
