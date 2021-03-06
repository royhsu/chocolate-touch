//
//  CatalogueTableViewController.swift
//  ChocolateExamples
//
//  Created by 許郁棋 on 2016/6/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData

public class CatalogueTableViewController: CHTableViewController {

    enum Row: Int {
        
        case cacheTableView
        
        var title: String {
            
            switch self {
            case .cacheTableView: return "Cache Table View"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [
        .cacheTableView
    ]
    
    
    // MARK: Init
    
    public override init() {
        
        super.init(style: .plain)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
    
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chocolate"
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rows.count
    
    }
    
    public override func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.text = rows[indexPath.row].title
        
    }
    
    
    // MARK: UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .cacheTableView:
            
            let controller = ProductTableViewController(productIdentifier: "123")
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        }
        
    }
    
}
