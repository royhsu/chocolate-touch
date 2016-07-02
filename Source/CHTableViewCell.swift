//
//  CHTableViewCell.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public class CHTableViewCell: UITableViewCell { }


// MARK: - Identifiable

extension CHTableViewCell: Identifiable {
    
    public class var identifier: String { return String(self) }
    
}
