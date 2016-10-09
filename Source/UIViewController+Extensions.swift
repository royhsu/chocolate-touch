//
//  UIViewController+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/10/7.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    /**
     A convenience loads a view controller from local xib file.
     
     - Author: Roy Hsu
     
     - Parameter nibName: The name of xib file.
     
     - Parameter bundle: The bundle xib file located. Default is nil.
     
     - Returns: The view controller instance.
     */
    
    public class func load(nibName name: String, bundle: Bundle? = nil) -> UIViewController? {
        
        return UINib.load(nibName: name, bundle: bundle) as? UIViewController
        
    }
    
}
