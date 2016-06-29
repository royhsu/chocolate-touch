//
//  MyTableViewCell.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell { }

extension MyTableViewCell: Identifiable {
    
    class var identifier: String { return String(self) }
    
}
