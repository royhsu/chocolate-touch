//
//  ViewController.swift
//  TWKitExamples
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit
import TWFoundation

class ViewController: UIViewController {

    private let tableViewController = TWTableViewController(cellType: MyTableViewCell.self)
    
    private var isLayouted = false
    
    private var names = [ "Roy", "Bob", "Allen", "Chris", "Helen" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tableView = tableViewController.tableView

        tableViewController.cellHeight = .Fixed(height: 44.0)
        tableViewController.cellConfigurator = { cell, index in
            
            cell.textLabel?.text = self.names[index]
            
        }
        tableViewController.numberOfRows = names.count
        
        view.addSubview(tableView)
        tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isLayouted {
            
            isLayouted = true
            
            tableViewController.view.frame = view.frame
            
        }
        
    }

}
