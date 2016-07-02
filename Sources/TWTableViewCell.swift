//
//  TWTableViewCell.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public class TWTableViewCell: UITableViewCell { }


// MARK: - Identifiable

extension TWTableViewCell: Identifiable {
    
    public class var identifier: String { return String(self) }
    
}
