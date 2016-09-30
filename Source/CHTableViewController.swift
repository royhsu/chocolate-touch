//
//  CHTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

public protocol CHTableViewDataSource: class {
    
    func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType
    
    func tableView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String?
    
    func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
}


// MARK: - CHTableViewController

open class CHTableViewController: UITableViewController {
    
    
    // MARK: Propery
    
    public weak var dataSource: CHTableViewDataSource?
    
    
    // MARK: Init
    
    public convenience init() {
        
        self.init(style: .plain)
        
    }
    
    public override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
        dataSource = self
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        dataSource = self
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightType =
            dataSource?.tableView(tableView, heightTypeForRowAt: indexPath) ??
            .fixed(44.0)
        
        switch heightType {
        case .dynamic: return 44.0
        case .fixed: return 0.0
        }
        
    }
    
    public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightType =
            dataSource?.tableView(tableView, heightTypeForRowAt: indexPath) ??
            .fixed(44.0)
        
        switch heightType {
        case .dynamic: return UITableViewAutomaticDimension
        case .fixed(let height): return height
        }
        
    }
    
    public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if let identifier = dataSource?.tableView(tableView, cellIdentifierForRowAt: indexPath) {
        
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        }
        else {
            
            cell = UITableViewCell()
            
        }
        
        dataSource?.configureCell(cell, forRowAt: indexPath)
        
        return cell
        
    }
    
}


// MARK: - CHTableViewDataSource

extension CHTableViewController: CHTableViewDataSource {
    
    open func tableView(_ tableView: UITableView, heightTypeForRowAt indexPath: IndexPath) -> HeightType {
        
        return .fixed(44.0)
        
    }
    
    open func tableView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String? {
        
        return nil
        
    }
    
    open func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
}
