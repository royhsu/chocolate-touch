//
//  TWTableViewCell.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class TWTableViewCell: UITableViewCell { }


// MARK: - Identifiable

extension TWTableViewCell: Identifiable {
    
    class var identifier: String { return String(self) }
    
}
