//
//  CacheContentView.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/13.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public class CacheContentView: UIView {

    
    // MARK: Property
    
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var subtitleLabel: UILabel!
    
}


// MARK: Init

extension CacheContentView {
    
    public class func view() -> CacheContentView {
        
        return UIView.view(nibNamed: "CacheContentView") as! CacheContentView
        
    }
    
}