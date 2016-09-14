//
//  CHTableViewCell.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import UIKit

open class CHTableViewCell: UITableViewCell {

    // MARK: Property
    
    public private(set) var containerView: UIView?
    
    
    // MARK: Init
    
    public init() {
        
        super.init(style: .default, reuseIdentifier: CHTableViewCell.identifier)
        
    }
    
    private override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        fatalError()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: Set Up
    
    public func setUp(containerView: UIView) {
        
        self.containerView?.removeFromSuperview()
        self.containerView = containerView
        
        self.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let topConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let leftConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .left,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .left,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let bottomConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        contentView.addConstraints([ leadingConstraint, topConstraint, leftConstraint, bottomConstraint ])
        
    }
    
}


// MARK: - Identifiable

extension CHTableViewCell: Identifiable {
    
    public class var identifier: String { return String(describing: self) }
    
}
