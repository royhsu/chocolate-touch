//
//  CHTableViewCell.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/14.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import UIKit

open class CHTableViewCell: UITableViewCell { }


// MARK: - Identifiable

extension CHTableViewCell: Identifiable {
    
    public class var identifier: String {
        
        return String(describing: self)
    
    }
    
}
