//
//  CHTableViewDataSource.swift
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

public protocol CHTableViewDataSource: class {
    
    func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType
    
    func tableView(_ tableView: UITableView, cellContentViewForRowAt indexPath: IndexPath) -> UIView?
    
}
