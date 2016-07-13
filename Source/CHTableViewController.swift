//
//  CHTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public class CHTableViewController: UITableViewController, CHTableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType { return .dynamic }
    
    public func tableView(_ tableView: UITableView, cellContentViewForRowAt indexPath: IndexPath) -> UIView? { return nil }
    
}
