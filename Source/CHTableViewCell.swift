//
//  CHTableViewCell.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/14.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import UIKit

public class CHTableViewCell: UITableViewCell {

    
    // MARK: Property
    
    public private(set) var containerView: UIView?
    
    
    // MARK: Set Up
    
    public func setUp(containerView: UIView) {
        
        self.containerView?.removeFromSuperview()
        self.containerView = containerView
        
        self.contentView.addSubview(containerView)
        
        containerView.pinEdgesToSuperview()
        
    }
    
}


// MARK: - Identifiable

extension CHTableViewCell: Identifiable {
    
    public class var identifier: String {
        
        return String(describing: self)
    
    }
    
}


// MARK: UIView

private extension UIView {
    
    func pinEdgesToSuperview() {
        
        guard
            let superview = self.superview
            else { fatalError("No superview exists.") }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: superview,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let top = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: superview,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let trailing = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: superview,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superview,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        superview.addConstraints([ leading, top, trailing, bottom ])
        
    }
    
}
