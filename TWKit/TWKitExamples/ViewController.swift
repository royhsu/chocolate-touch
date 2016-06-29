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

    private let tableViewController = TWTableViewController(nibType: MyTableViewCell.self)
    
    private var isLayouted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tableView = tableViewController.tableView
        
        tableViewController.cellHeight = .Fixed(height: 44.0)
        tableViewController.cellConfigurator = { cell in
            
            cell.textLabel?.text = "Hello World"
            
        }
        tableViewController.numberOfRows = 10
        
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
