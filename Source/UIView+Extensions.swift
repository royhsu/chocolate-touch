//
//  UIView+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/13.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public extension UIView {
    
    /**
     A convenience method that help you to generate a view from local xib file.
     
     - Author: Roy Hsu
     
     - Parameter nibNamed: The name of xib file.
     
     - Parameter bundle: The bundle xib file located. Default is nil.
     
     - Returns: The view instance.
     */
    
    public class func view(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        
        return UINib(nibName: nibNamed, bundle: bundle)
            .instantiate(withOwner: nil, options: nil)
            .first as? UIView
    
    }
        
}
