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
    
    func registerCellType<Cell: UITableViewCell>(_ cellType: Cell.Type) where Cell: Identifiable {
        
        register(cellType, forCellReuseIdentifier: cellType.identifier)
        
    }
    
    func registerCellNibType<Cell: UITableViewCell>(_ nibType: Cell.Type, bundle: Bundle? = nil) where Cell: Identifiable {
        
        registerNib(nibName: nibType.identifier, bundle: bundle)
        
    }
    
    func registerNib(nibName: String, bundle: Bundle? = nil) {
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: nibName)
        
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell where Cell: Identifiable {
        
        return dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        
    }
    
    func cellForRow<Cell: UITableViewCell>(at indexPath: IndexPath) -> Cell? where Cell: Identifiable {
        
        return cellForRow(at: indexPath) as? Cell
        
    }
    
}
