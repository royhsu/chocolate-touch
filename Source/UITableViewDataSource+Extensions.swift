//
//  UITableViewDataSource+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/13.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public enum HeightType {
    case dynamic
    case fixed(height: CGFloat)
}

public extension UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    func tableView(_ tableView: UITableView, containerViewForRowAt indexPath: IndexPath) -> UIView? {
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, configurationForRowAt indexPath: IndexPath) { }
    
}
