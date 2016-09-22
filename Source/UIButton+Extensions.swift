//
//  UIButton+Extensions.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/22.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public extension UIButton {
    
    /**
     Set the different background colors when state changes.
     
     - Author: Roy Hsu
     
     - Parameter color: The background color.
     
     - Parameter state: The target control state.
     */
    
    func setBackgroundColor(_ color: UIColor, forState state: UIControlState) {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: state)
        
    }
    
}
