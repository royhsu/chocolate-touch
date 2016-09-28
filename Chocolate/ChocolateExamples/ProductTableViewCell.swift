//
//  ProductTableViewCell.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import UIKit

class ProductTableViewCell: UITableViewCell { }


// MARK: - Identifiable

extension ProductTableViewCell: Identifiable {
    
    class var identifier: String { return String(describing: self) }
    
}
