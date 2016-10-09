//
//  UINib+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/10/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public extension UINib {
    
    /**
     A convenience method loads a local xib file.
     
     - Author: Roy Hsu
     
     - Parameter nibName: The name of xib file.
     
     - Parameter bundle: The bundle xib file located. Default is nil.
     
     - Returns: The loaded instance.
     */
    
    public class func load(nibName name: String, bundle: Bundle? = nil) -> Any? {
        
        return
            UINib(nibName: name, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)
                .first
        
    }
    
}
